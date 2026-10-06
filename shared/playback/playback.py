#!/usr/bin/env python3
"""Record and replay the `claude` and `dbt` calls a demo makes.

runner.sh puts shared/playback/bin first on PATH when DEMO_PLAYBACK is
`record` or `replay`, so every `claude` or `dbt` call in a step lands here.

  record  run the real command, pass its output through, then save the output,
          exit code and duration to <demo>/recording/calls/<id>.json and the
          demo's working files to <demo>/recording/snapshots/<id>.tar.gz
  replay  wait a few seconds, restore the saved files, print the saved output
          and exit with the saved code

A call's id is the tool, a hash of its prompt (claude) or arguments (dbt),
with the repo path taken out so a recording works from any checkout, and how
many times the same call has run before in this demo run.
"""

from __future__ import annotations

import hashlib
import json
import os
import subprocess
import sys
import tarfile
import threading
import time
from pathlib import Path

# What a demo changes. Same list reset.sh wipes, less the DuckDB files and dbt's
# build output: dbt calls are replayed too, so nothing reads them.
STATE = [".wire", "dbt", "dashboards", "semantic_layer"]
SKIP = {"dbt/target", "dbt/logs", "dbt/dbt_packages"}


def call_args(argv: list[str]) -> list[str]:
    root = os.environ.get("WIRE_DEMOS_ROOT", "")
    out, skip = [], False
    for a in argv:
        if skip:
            skip = False
            continue
        if a == "--model":
            skip = True
            continue
        out.append(a.replace(root, "<root>") if root else a)
    return out


def call_key(tool: str, args: list[str]) -> list[str]:
    """What identifies a call: for claude only the prompt, so a recording made
    with one model or set of options replays under any other."""
    if tool == "claude" and "-p" in args and args.index("-p") + 1 < len(args):
        return [args[args.index("-p") + 1]]
    return args


def call_id(tool: str, args: list[str], demo: Path) -> str:
    digest = hashlib.sha1(json.dumps([tool, call_key(tool, args)]).encode()).hexdigest()[:10]
    counts_file = demo / "logs" / ".playback-counts.json"
    counts_file.parent.mkdir(parents=True, exist_ok=True)
    counts = json.loads(counts_file.read_text()) if counts_file.exists() else {}
    key = f"{tool}-{digest}"
    counts[key] = counts.get(key, 0) + 1
    counts_file.write_text(json.dumps(counts))
    return f"{key}-{counts[key]}"


def skipped(info: tarfile.TarInfo) -> tarfile.TarInfo | None:
    name = info.name
    if any(name == s or name.startswith(s + "/") for s in SKIP) or ".duckdb" in name:
        return None
    return info


def snapshot(demo: Path, dest: Path) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    with tarfile.open(dest, "w:gz") as tar:
        for name in STATE:
            if (demo / name).exists():
                tar.add(demo / name, arcname=name, filter=skipped)


def restore(demo: Path, src: Path) -> None:
    for name in STATE:
        subprocess.run(["rm", "-rf", str(demo / name)], check=True)
    with tarfile.open(src) as tar:
        tar.extractall(demo, filter="data")


def tee(stream, sink, keep: list[str]) -> None:
    for line in iter(stream.readline, ""):
        keep.append(line)
        sink.write(line)
        sink.flush()


def record(tool: str, argv: list[str], demo: Path, rec: Path, cid: str) -> int:
    real = os.environ.get(f"REAL_{tool.upper()}")
    if not real:
        print(f"playback: REAL_{tool.upper()} is not set", file=sys.stderr)
        return 127
    started = time.time()
    # Hand the real command a PATH without the stand-ins, so Claude Code's own
    # dbt and claude calls run for real and the recording never mentions them.
    shims = str(Path(__file__).resolve().parent / "bin")
    path = os.pathsep.join(p for p in os.environ.get("PATH", "").split(os.pathsep)
                           if p and Path(p).resolve() != Path(shims))
    env = {**os.environ, "PATH": path}
    proc = subprocess.Popen([real, *argv], stdin=subprocess.DEVNULL, stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE, text=True, env=env)
    out: list[str] = []
    err: list[str] = []
    threads = [threading.Thread(target=tee, args=(proc.stdout, sys.stdout, out)),
               threading.Thread(target=tee, args=(proc.stderr, sys.stderr, err))]
    for t in threads:
        t.start()
    for t in threads:
        t.join()
    rc = proc.wait()
    snapshot(demo, rec / "snapshots" / f"{cid}.tar.gz")
    (rec / "calls").mkdir(parents=True, exist_ok=True)
    (rec / "calls" / f"{cid}.json").write_text(json.dumps({
        "tool": tool, "args": call_args(argv), "rc": rc,
        "duration_s": round(time.time() - started), "stdout": "".join(out), "stderr": "".join(err),
    }, indent=2, ensure_ascii=False))
    return rc


def label_for(tool: str, args: list[str]) -> str:
    """What the spinner names: the Wire command, as Claude Code shows it."""
    if tool == "dbt":
        return "dbt " + " ".join(a for a in args[:1])
    prompt = call_key(tool, args)[0] if args else ""
    first = prompt.split()[0].rstrip(".") if prompt.split() else ""
    return first if first.startswith("/wire:") else "Working"


def wait(tool: str, duration: int, label: str) -> None:
    """Hold for a short, scaled version of the recorded time, with a spinner on
    the terminal (the caller usually sends stdout and stderr to a log)."""
    speed = float(os.environ.get("DEMO_REPLAY_SPEED", "1"))
    seconds = min(max(duration / 20, 2), 10) / speed if tool == "claude" else min(max(duration / 5, 1), 4) / speed
    try:
        tty = open("/dev/tty", "w")
    except OSError:
        time.sleep(seconds)
        return
    frames = "⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
    took = f"({duration // 60}m {duration % 60:02d}s in the recorded run)"
    end = time.time() + seconds
    n = 0
    with tty:
        while time.time() < end:
            tty.write(f"\r  {frames[n % len(frames)]} \033[2m{label} {took}\033[0m")
            tty.flush()
            n += 1
            time.sleep(0.08)
        tty.write(f"\r\033[K  \033[2m⏺ {label}\033[0m\n\n")
        tty.flush()


def replay(tool: str, demo: Path, rec: Path, cid: str) -> int:
    call = rec / "calls" / f"{cid}.json"
    if not call.exists():
        print(f"playback: no recording for this {tool} call ({cid}). "
              f"Record the demo again, or run it live with DEMO_PLAYBACK=live.", file=sys.stderr)
        return 1
    saved = json.loads(call.read_text())
    wait(tool, saved["duration_s"], label_for(tool, saved["args"]))
    snap = rec / "snapshots" / f"{cid}.tar.gz"
    if snap.exists():
        restore(demo, snap)
    sys.stdout.write(saved["stdout"])
    sys.stderr.write(saved["stderr"])
    return saved["rc"]


def main() -> int:
    tool, argv = sys.argv[1], sys.argv[2:]
    mode = os.environ.get("DEMO_PLAYBACK", "")
    demo = Path(os.environ["DEMO_DIR"])
    rec = demo / "recording"
    # Wire's own calls to `claude` that are not demo steps (version checks and
    # the like) pass straight through.
    if tool == "claude" and argv and argv[0] in ("--version", "plugin", "mcp", "config"):
        os.execv(os.environ["REAL_CLAUDE"], [os.environ["REAL_CLAUDE"], *argv])
    cid = call_id(tool, call_args(argv), demo)
    if mode == "record":
        return record(tool, argv, demo, rec, cid)
    return replay(tool, demo, rec, cid)


if __name__ == "__main__":
    sys.exit(main())
