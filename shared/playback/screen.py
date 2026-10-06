#!/usr/bin/env python3
"""Show a Wire call the way Claude Code shows it, as in the release director demo.

  screen.py say <message>     type the message after a "> " prompt
  screen.py reply <log file>  print Claude's reply, formatted as Markdown

runner.sh calls this for every run_wire. It needs `rich` (in .venv); without
it, messages and replies print as plain text.
"""

from __future__ import annotations

import os
import sys
import time

try:
    from rich.console import Console
    from rich.markdown import Markdown
    from rich.padding import Padding
    from rich.text import Text
    from rich.theme import Theme
except ImportError:  # plain fallback
    Console = None

SPEED = float(os.environ.get("DEMO_REPLAY_SPEED", "1"))
# Messages longer than this print at once; typing them would take too long.
TYPE_LIMIT = 160


def console():
    # Same colours as the release director demo: the terminal's own text
    # colour, so replies read on light and dark backgrounds.
    return Console(highlight=False, theme=Theme({
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


def say(message: str) -> None:
    if Console is None:
        print(f"> {message}\n")
        return
    out = console()
    out.print(Text("> ", style="bold"), end="")
    if len(message) <= TYPE_LIMIT and sys.stdout.isatty():
        for ch in message:
            out.print(ch, end="", style="bold")
            time.sleep(1 / (28 * SPEED))
        out.print()
    else:
        out.print(Text(message, style="bold"))
    out.print()


def reply(path: str) -> None:
    text = open(path, encoding="utf-8", errors="replace").read().strip()
    if Console is None:
        print(text)
        return
    out = console()
    for segs in out.render_lines(Padding(Markdown(text), (0, 0, 0, 2)), pad=False):
        out.print(Text.assemble(*[(s.text, s.style) for s in segs]))
        if sys.stdout.isatty():
            time.sleep(0.025 / SPEED)


if __name__ == "__main__":
    if sys.argv[1] == "say":
        say(sys.argv[2])
    else:
        reply(sys.argv[2])
