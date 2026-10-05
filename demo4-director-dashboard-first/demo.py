#!/usr/bin/env python3
"""Demo 4: a release director runs a dashboard_first release with Wire.

  demo.py reset [--recording]   fresh workspace (a new client repo holding the SOW);
                                --recording also deletes the recording
  demo.py record <id> [--to id] run steps live in Claude Code and save each reply
  demo.py play [--auto]         replay the recording: typed messages, Wire's
                                replies, Studio and the mockup in the browser
  demo.py list                  steps and whether each is recorded

Recording keeps, for each step, the Claude Code event stream and a snapshot of
the workspace afterwards. Playback restores each snapshot as its step finishes,
so Wire Studio, which reads the workspace, moves forward with the story.
"""
from __future__ import annotations

import argparse
import glob
import json
import os
import re
import shutil
import signal
import socket
import subprocess
import sys
import termios
import threading
import time
import tty
from pathlib import Path

import yaml
from rich.console import Console
from rich.live import Live
from rich.markdown import Markdown
from rich.padding import Padding
from rich.spinner import Spinner
from rich.text import Text
from rich.theme import Theme

HERE = Path(__file__).resolve().parent
WORK = Path(os.environ.get("DEMO_WORKSPACE", HERE / "workspace"))
REC = HERE / "recording"
SNAP = REC / "snapshots"
STEPS = yaml.safe_load((HERE / "steps.yaml").read_text())["steps"]
MCP_EMPTY = HERE.parent / "shared" / "mcp-empty.json"
STUDIO_PORT = int(os.environ.get("DEMO_STUDIO_PORT", "4800"))
STUDIO_URL = f"http://127.0.0.1:{STUDIO_PORT}/"

# rich's default Markdown colours (cyan code on a black box, blue links) are
# hard to read on a light terminal. Use the terminal's own text colour, so the
# replay reads on light and dark themes alike.
console = Console(highlight=False, theme=Theme({
    "markdown.code": "bold",
    "markdown.code_block": "none",
    "markdown.link": "bold underline",
    "markdown.link_url": "underline",
    "markdown.h1": "bold",
    "markdown.h2": "bold underline",
    "markdown.h3": "bold",
    "markdown.h4": "italic",
    "markdown.block_quote": "italic",
    "markdown.list": "none",
    "markdown.item.number": "none",
    "markdown.table.border": "dim",
    "markdown.table.header": "bold",
    "markdown.kbd": "bold",
}))


# ── steps and recording files ────────────────────────────────────────────────

def index_of(step_id: str) -> int:
    for i, s in enumerate(STEPS):
        if s["id"] == step_id or str(i + 1) == step_id:
            return i
    sys.exit(f"no step {step_id!r}; see `demo.py list`")


def stem(i: int) -> str:
    return f"{i + 1:02d}-{STEPS[i]['id']}"


def meta_path(i: int) -> Path:
    return REC / f"{stem(i)}.meta.json"


def events_path(i: int) -> Path:
    return REC / f"{stem(i)}.jsonl"


def replay_path(i: int) -> Path:
    return REC / f"{stem(i)}.replay.json"


def export(i: int) -> None:
    """Write what the audience sees for a step: commands and lanes run, and the
    final reply. The raw event stream stays local (it is the full transcript)."""
    if not events_path(i).exists():
        return
    turn = parse(events_path(i), STEPS[i].get("hide"))
    replay_path(i).write_text(json.dumps(turn, indent=2, ensure_ascii=False))


def studio_script() -> Path:
    found = sorted(glob.glob(os.path.expanduser("~/.claude/plugins/cache/rittman-analytics/wire/*/studio/studio.py")))
    if found:
        return Path(found[-1])
    return Path.home() / "github/wire/wire/studio/studio.py"


# ── reset ────────────────────────────────────────────────────────────────────

def reset(clear_recording: bool) -> None:
    if WORK.exists():
        shutil.rmtree(WORK)
    (WORK / "client").mkdir(parents=True)
    shutil.copy(HERE / "client" / "claybrook_sow.md", WORK / "client" / "claybrook_sow.md")
    (WORK / "README.md").write_text("# Claybrook Media Group: analytics\n")
    git = ["git", "-C", str(WORK)]
    subprocess.run(git + ["init", "-q", "-b", "main"], check=True)
    subprocess.run(git + ["add", "-A"], check=True)
    subprocess.run(git + ["-c", "user.name=Mark Rittman", "-c", "user.email=mark.rittman@rittmananalytics.com",
                          "commit", "-q", "-m", "Claybrook SOW"], check=True)
    if clear_recording and REC.exists():
        shutil.rmtree(REC)
    SNAP.mkdir(parents=True, exist_ok=True)
    snapshot(-1)
    print(f"workspace reset: {WORK}")


def snapshot(i: int, dest: Path | None = None) -> None:
    dest = dest or SNAP / ("00-start" if i < 0 else stem(i))
    if dest.exists():
        shutil.rmtree(dest)
    shutil.copytree(WORK, dest, symlinks=True,
                    ignore=shutil.ignore_patterns(".git", "target", "dbt_packages", "logs", ".venv", "*.duckdb", "*.duckdb.wal"))


def progress_dir(i: int) -> Path:
    return SNAP / f"{stem(i)}.progress"


def fingerprint() -> tuple:
    return tuple(sorted((str(p), p.stat().st_mtime_ns, p.stat().st_size)
                        for p in (WORK / ".wire").rglob("*") if p.is_file()))


def watch_progress(i: int, stop: threading.Event, every: float = 20.0) -> None:
    """Snapshot the workspace while a step runs, whenever it has changed."""
    if progress_dir(i).exists():
        shutil.rmtree(progress_dir(i))
    started, last = time.time(), None
    while not stop.wait(every):
        try:
            fp = fingerprint()
            if fp != last:
                snapshot(i, progress_dir(i) / f"{int(time.time() - started):05d}")
                last = fp
        except OSError:
            pass


def restore(i: int) -> None:
    restore_path(SNAP / ("00-start" if i < 0 else stem(i)))


def restore_path(src: Path) -> None:
    if not src.exists():
        return
    subprocess.run(["rsync", "-a", "--delete", "--exclude", ".git", f"{src}/", f"{WORK}/"], check=True)
    make_current()


def make_current() -> None:
    """Studio judges lanes and the release claim by how recently they were
    written. A replay runs a day or more after the recording, so mark lane files
    and the claim as written now; otherwise Studio would show them as stalled."""
    now = time.time()
    stamp = time.strftime("%Y-%m-%d %H:%M")
    for lane in WORK.glob(".wire/releases/*/lanes/*.md"):
        os.utime(lane, (now, now))
    for status in WORK.glob(".wire/releases/*/status.md"):
        text = status.read_text()
        new = re.sub(r'^(\s+(?:claimed_at|last_write):\s*)"\d{4}-\d{2}-\d{2} \d{2}:\d{2}"', rf'\g<1>"{stamp}"', text, flags=re.M)
        if new != text:
            status.write_text(new)


# ── record ───────────────────────────────────────────────────────────────────

def previous_session(step: int) -> str | None:
    for i in range(step - 1, -1, -1):
        if meta_path(i).exists():
            sid = json.loads(meta_path(i).read_text()).get("session_id")
            if sid:
                return sid
    return None


def record(first: int, last: int) -> None:
    for i in range(first, last + 1):
        step = STEPS[i]
        restore(i - 1)
        started = time.time()
        meta: dict = {"id": step["id"], "say": step["say"]}
        if step.get("kind") == "studio":
            meta["duration_s"] = 0
        else:
            sid = previous_session(i)
            cmd = ["claude", "-p", step["say"], "--output-format", "stream-json", "--verbose",
                   "--permission-mode", "bypassPermissions",
                   "--strict-mcp-config", "--mcp-config", str(MCP_EMPTY)]
            if sid:
                cmd += ["--resume", sid]
            venv_bin = HERE.parent / ".venv" / "bin"
            env = {**os.environ, "WIRE_TELEMETRY": "false", "PATH": f"{venv_bin}:{os.environ['PATH']}"}
            print(f"[{stem(i)}] recording (resume {sid or 'new session'})", flush=True)
            stop = threading.Event()
            watcher = threading.Thread(target=watch_progress, args=(i, stop), daemon=True)
            watcher.start()
            with events_path(i).open("w") as out:
                proc = subprocess.Popen(cmd, cwd=WORK, env=env, stdin=subprocess.DEVNULL, stdout=subprocess.PIPE, text=True)
                for line in proc.stdout:
                    out.write(line)
                    out.flush()
                    try:
                        ev = json.loads(line)
                    except json.JSONDecodeError:
                        continue
                    if ev.get("session_id"):
                        meta["session_id"] = ev["session_id"]
                    if ev.get("type") == "result":
                        meta["result"] = {k: ev.get(k) for k in ("subtype", "is_error", "duration_ms", "total_cost_usd", "num_turns")}
                proc.wait()
            stop.set()
            watcher.join()
            meta["duration_s"] = round(time.time() - started)
            meta["opens"] = resolve_opens(step)
            final = parse(events_path(i), step.get("hide"))["final"]
            print(f"[{stem(i)}] done in {meta['duration_s']}s\n{final}\n", flush=True)
        snapshot(i)
        head = subprocess.run(["git", "-C", str(WORK), "rev-parse", "--short", "HEAD"], capture_output=True, text=True)
        meta["git_head"] = head.stdout.strip()
        meta_path(i).write_text(json.dumps(meta, indent=2))
        export(i)


def resolve_opens(step: dict) -> list[str]:
    opens = []
    for target in step.get("open", []):
        if target == "mock":
            mocks = sorted(WORK.glob(".wire/releases/*/design/mockups/*.html"), key=lambda p: p.stat().st_mtime)
            opens += [str(p.relative_to(WORK)) for p in mocks[-2:]]
        else:
            opens.append(target)
    return opens


# ── parse a recorded turn ────────────────────────────────────────────────────

def parse(path: Path, hide: list[str] | None = None) -> dict:
    """What the audience sees: Wire commands run, lanes dispatched, final reply."""
    activity: list[str] = []
    texts: list[str] = []
    after_tool = False
    for line in path.read_text().splitlines():
        try:
            ev = json.loads(line)
        except json.JSONDecodeError:
            continue
        if ev.get("type") != "assistant" or ev.get("parent_tool_use_id"):
            continue
        for block in ev["message"].get("content", []):
            if block.get("type") == "text" and block["text"].strip():
                if after_tool:
                    texts = []
                    after_tool = False
                texts.append(block["text"].strip())
            elif block.get("type") == "tool_use":
                after_tool = True
                name, inp = block["name"], block.get("input", {})
                if name == "Skill" and str(inp.get("skill", "")).startswith("wire:"):
                    raw = str(inp.get("args") or "").strip()
                    args = f" {raw}" if raw and len(raw) <= 40 and "\n" not in raw else ""
                    activity.append(f"/{inp['skill']}{args}")
                elif name in ("Agent", "Task"):
                    who = inp.get("subagent_type", "agent").removesuffix(":AGENT").split(":")[-1]
                    activity.append(f"lane: {who}, {inp.get('description', '')}".rstrip(", "))
    final = "\n\n".join(texts)
    if hide:
        final = "\n".join(l for l in final.splitlines() if not any(h in l for h in hide))
    return {"activity": activity, "final": final}


# ── play ─────────────────────────────────────────────────────────────────────

def wait_key(auto: bool, pause: float) -> None:
    if auto:
        time.sleep(pause)
        return
    fd = sys.stdin.fileno()
    old = termios.tcgetattr(fd)
    try:
        tty.setcbreak(fd)
        ch = sys.stdin.read(1)
        if ch in ("q", "\x03"):
            raise KeyboardInterrupt
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old)


def type_out(text: str, cps: float) -> None:
    console.print(Text("> ", style="bold"), end="")
    for ch in text:
        console.print(ch, end="", style="bold")
        time.sleep(1 / cps)
    console.print()


def show_reply(text: str, line_delay: float) -> None:
    rendered = console.render_lines(Padding(Markdown(text), (0, 0, 0, 2)), pad=False)
    for segs in rendered:
        console.print(Text.assemble(*[(s.text, s.style) for s in segs]))
        time.sleep(line_delay)


def run_spinner(activity: list[str], seconds: float, progress: list[tuple[float, Path]]) -> None:
    """Show each Wire command and lane in turn while replaying the workspace
    snapshots taken during the step, at the same relative points in time."""
    items = activity or ["Working..."]
    per = seconds / len(items)
    pending = list(progress)
    started = time.time()
    with Live(console=console, refresh_per_second=12, transient=True) as live:
        for n, item in enumerate(items):
            live.update(Spinner("dots", text=Text(f" {item}", style="dim")))
            until = started + per * (n + 1)
            while time.time() < until:
                elapsed = time.time() - started
                while pending and pending[0][0] * seconds <= elapsed:
                    restore_path(pending.pop(0)[1])
                time.sleep(0.1)
            if activity:
                live.console.print(Text(f"  ⏺ {item}", style="dim"))


def progress_of(i: int, duration: float) -> list[tuple[float, Path]]:
    """Progress snapshots as (fraction of the step, path)."""
    snaps = sorted(progress_dir(i).glob("*")) if progress_dir(i).exists() else []
    return [(min(int(p.name) / max(duration, 1), 1.0), p) for p in snaps]


def has_lanes(progress: list[tuple[float, Path]]) -> bool:
    return any(any(p.glob(".wire/releases/*/lanes/*.md")) for _, p in progress)


def open_target(target: str) -> None:
    if os.environ.get("DEMO_NO_OPEN"):
        console.print(Text(f"[would open {target}]", style="dim"))
        return
    if target == "studio":
        ensure_studio()
        subprocess.run(["open", STUDIO_URL])
    else:
        subprocess.run(["open", str(WORK / target)])


studio: subprocess.Popen | None = None


def ensure_studio() -> None:
    """Start Studio once the workspace has a .wire/ folder (Studio exits
    without one), then wait until it answers so the browser can connect."""
    global studio
    if studio and studio.poll() is None:
        return
    script = studio_script()
    if not script.exists() or not (WORK / ".wire").is_dir():
        return
    studio = subprocess.Popen(["python3", str(script), "--repo", str(WORK), "--port", str(STUDIO_PORT), "--no-browser"],
                              stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, start_new_session=True)
    deadline = time.time() + 10
    while time.time() < deadline and studio.poll() is None:
        try:
            socket.create_connection(("127.0.0.1", STUDIO_PORT), timeout=0.5).close()
            return
        except OSError:
            time.sleep(0.2)


def stop_studio() -> None:
    if studio and studio.poll() is None:
        try:
            os.killpg(studio.pid, signal.SIGTERM)
        except OSError:
            studio.terminate()


def play(auto: bool, start: int, speed: float, show_times: bool) -> None:
    restore(start - 1)
    ensure_studio()
    try:
        console.clear()
        console.print(Text(" ✻ Claude Code  ·  Wire 4.1  ·  ~/claybrook-media-group ", style="bold reverse"))
        console.print()
        for i in range(start, len(STEPS)):
            step = STEPS[i]
            meta = json.loads(meta_path(i).read_text()) if meta_path(i).exists() else None
            if meta is None and step.get("kind") != "studio":
                console.print(Text(f"[step {stem(i)} not recorded]", style="red"))
                break
            wait_key(auto, 2.0)
            type_out(step["say"], cps=28 * speed)
            time.sleep(0.4)
            console.print()
            if step.get("kind") == "studio":
                restore(i)
                ensure_studio()
                console.print(Text(f"  Wire Studio is running for this repository at {STUDIO_URL} (stop it with /wire-studio stop).", style="dim"))
            else:
                turn = json.loads(replay_path(i).read_text())
                progress = progress_of(i, meta["duration_s"])
                seconds = step.get("hold") or (30 if has_lanes(progress) else min(max(meta["duration_s"] / 40, 3), 12))
                run_spinner(turn["activity"], seconds / speed, progress)
                restore(i)
                if show_times:
                    console.print(Text(f"  ({meta['duration_s'] // 60}m {meta['duration_s'] % 60:02d}s in the recorded run)", style="dim"))
                console.print()
                show_reply(turn["final"], line_delay=0.025 / speed)
            for target in (meta or {}).get("opens", step.get("open", [])):
                open_target(target)
            console.print()
        wait_key(auto, 1.0)
    except KeyboardInterrupt:
        pass
    finally:
        stop_studio()


# ── main ─────────────────────────────────────────────────────────────────────

def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    rs = sub.add_parser("reset")
    rs.add_argument("--recording", action="store_true", help="also delete the recording")
    sub.add_parser("list")
    sub.add_parser("export", help="rewrite every step's replay file from its recording")
    r = sub.add_parser("record")
    r.add_argument("step")
    r.add_argument("--to")
    p = sub.add_parser("play")
    p.add_argument("--auto", action="store_true", help="run straight through without key presses")
    p.add_argument("--from", dest="start", default="1", help="step id or number to start from")
    p.add_argument("--speed", type=float, default=1.0, help="faster above 1, slower below")
    p.add_argument("--show-times", action="store_true", help="show how long each step took when recorded")
    a = ap.parse_args()
    if a.cmd == "reset":
        reset(a.recording)
    elif a.cmd == "export":
        for i in range(len(STEPS)):
            export(i)
    elif a.cmd == "list":
        for i, s in enumerate(STEPS):
            done = "recorded" if meta_path(i).exists() else "-"
            print(f"{stem(i):28} {done:9} {s['say'][:70]}")
    elif a.cmd == "record":
        first = index_of(a.step)
        record(first, index_of(a.to) if a.to else first)
    elif a.cmd == "play":
        play(a.auto, index_of(a.start), a.speed, a.show_times)


if __name__ == "__main__":
    main()
