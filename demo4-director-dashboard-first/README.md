# Demo 4: release director, dashboard first

A 15 to 20 minute demo of Wire 4.1 run the way a release director runs it. You type plain-English directions, Wire runs the commands and stops at each approval. The client is Claybrook Media Group, a made-up UK digital publisher (the same scenario as the dashboard-first tutorial). The demo goes from the statement of work (SOW) to an approved mockup, seed data and a dbt project that builds on DuckDB. It does not touch live data or Looker.

## How it works

The release was run for real in Claude Code with Wire and recorded. `demo.py play` replays that recording:

- It types each director message, then shows the Wire commands that ran and Wire's reply. Nothing else is shown.
- After each step it moves the demo repository forward to the state the recorded run left it in, so Wire Studio, open in the browser, updates as the story goes.
- It opens Wire Studio and the dashboard mockup in the browser at the right moments.

Live, the same release took about an hour, because each Wire command takes minutes. The replay compresses each step's waiting time to 3 to 30 seconds. Steps that run lanes hold for 30 seconds while the replay plays the snapshots taken during the step, so Studio, which refreshes every 15 seconds, shows lanes running and then completing. Tell the audience the run was recorded and sped up; `--show-times` shows how long each step took live.

## Before the demo

```bash
cd ~/github/wire-demos
.venv/bin/python demo4-director-dashboard-first/demo.py list     # every step should say "recorded"
.venv/bin/python demo4-director-dashboard-first/demo.py play --auto --speed 4   # quick rehearsal
```

- Use a terminal of about 120 by 40 characters, with a large font. Put the browser on the second screen or beside the terminal.
- Wire Studio uses port 4800. Stop any other Studio first (`/wire-studio stop` in a Claude Code session).
- The replay needs Wire 4.1 or later installed (for Studio), Python with `rich` and `pyyaml` (both in `.venv`), and macOS (`open` launches the browser).

## Running it

```bash
cd ~/github/wire-demos
.venv/bin/python demo4-director-dashboard-first/demo.py play
```

Press any key to type and send the next message. Press `q` to stop. Options:

| Option | Effect |
|---|---|
| `--auto` | Runs straight through, with a 2-second pause between steps |
| `--speed 1.5` | Types and replies faster (below 1 is slower) |
| `--from <step>` | Starts at a step, by number or id, with the repository already in the state before it |
| `--show-times` | Shows how long each step took in the recorded run |

## The steps and what to say

| # | You type (the replay types it) | Wire does | Show and say |
|---|---|---|---|
| 1 | Set up Claybrook as a dashboard-first release, lanes in Studio, made-up names | Runs `/wire:new`, reads the SOW, proposes every setting with its source, records your rulings | Wire reads the contract and proposes; the director decides. Nothing is written until you confirm. |
| 2 | Yes, go ahead | Creates the engagement, the release record and the branch, and claims the release | One person directs each release; the claim stops a second session from dispatching into it. |
| 3 | `/wire-studio` | Opens Wire Studio in the browser | The release on one page: artifact graph, what can run next, decisions waiting, lanes, AI spend. Studio only reads; it never writes the record. |
| 4 | Go ahead with the requirements | A requirements lane drafts and validates the specification (11 checks), then stops for approval | Every step runs a real Wire command. It stops at the gate and lists the questions for the client. |
| 5 | Priya approves; start the conceptual model and mockups as two lanes | Two lanes run in parallel; the two mockups open in the browser | Switch to Studio: two lanes running. Then click through the mockups: Looker-style, interactive, made-up data. |
| 6 | Priya's feedback: weekly CPM line, table at the bottom | Round 2 of the mockups; both open again | Iterate on the design before any data work. Point at the weekly CPM line. |
| 7 | Round 2 approved; carry on to the viz catalog, data model and seed data | Viz catalog and data model lanes; stops for data model approval | The data model is derived from the approved mockup: 7 models and the 18 tests the SOW asks for. |
| 8 | Data model approved; make the seed data | Seed data lane writes 4 CSV files and checks them (46 checks) | Realistic, linked sample data, so the whole build runs before the client grants any access. |
| 9 | Seeds approved; build dbt on local DuckDB and run it | dbt lane writes 2 staging and 5 warehouse models; `dbt build` passes 29 of 29, all 18 tests | The SOW's acceptance test, met on a laptop with no client systems. |
| 10 | Where are we, and what's next? | Status summary: done, approved by whom, what is next | Switch to Studio for the final picture. Next would be LookML and Looker, out of scope today. |

Playback alone takes about 5 minutes; the rest of the 20 is for talking and the browser.

## Re-recording

Only the replay files (`recording/*.replay.json`, what the audience sees) and the snapshots are committed. The raw event streams (`recording/*.jsonl`) are full session transcripts and stay on the recording machine; run `demo.py export` there after changing a step's `hide` list.

`demo.py reset --recording` clears the workspace and the recording. `demo.py record <step> --to <step>` runs steps live in Claude Code (Wire telemetry off, no MCP servers) and saves each reply and a snapshot of the repository. Edit `steps.yaml` to change what the director says; re-record from the first changed step onwards, because each step continues the same Claude Code session.
