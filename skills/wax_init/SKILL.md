---
name: wax_init
description: >
  Set up the .agents folder for a project: copy this reference design into a target project
  (a path you are given, or the project you are standing in), fill in the project name, and
  verify the result. Also checks an existing .agents
  folder for structural problems. Use whenever someone wants to "add .agents", "set up the
  agent workspace", "bootstrap agents for this repo", "install the handoff system", or asks
  whether a project's .agents is set up correctly, even if they do not name this skill.
  Triggers: setup, bootstrap, init, install .agents, new project, check .agents, verify setup.
---

# wax_init

Creates a fresh `.agents/` in a project from this reference design, and checks existing ones.
Two procedures: `setup` and `check`. The deterministic work lives in two scripts under
`scripts/`, so every copy comes out identical and the checks are the same ones `wax_handoff`
runs. All paths below are relative to `.agents/` unless stated.

## Invariants

- Setup never overwrites. If `<target>/.agents` exists, it stops and points at `check` (P-09).
- Setup is the only moment preferences change without a quoted human instruction (R-15).
  Rules never change.
- A new copy starts with `handoffs/` exactly as shipped in the public repository: the template
  plus one genesis entry whose exit point tells the first session to explore the project
  before doing any work. Run setup from a clone of the public repository, never from a tree
  that holds its own entries (R-04 permits filling the project name into the genesis entry;
  afterwards only `wax_handoff` touches `handoffs/`).
- The copy carries no git metadata. The target project's own version control owns it.
- `check` is read-only. It reports; it never repairs (R-09).

## Procedure: setup

1. Determine the target project root. If the human gave a path, use it. If not, use the
   project you are working in: the directory that holds the repository, not a subfolder.
   Say which one you chose before running anything, because the copy lands there.
2. Determine the project name. Default is the target folder's basename; use the human's
   wording if they named the project. It replaces `<project>` in the new `AGENTS.md`.
3. Run `scripts/setup.sh <target> --name <name>`. The script copies this `.agents/` to
   `<target>/.agents`, strips `.git`, fills the project name in `AGENTS.md` and in the genesis
   entry, and runs `check.sh` on the result.
4. Read the script output. A line starting with `FAIL` means nothing was changed, or the
   check found a problem in the copy; report it verbatim and stop (P-08).
5. Walk through `PREFERENCES.md` in the new copy with the human (R-15). List each preference
   in one line and ask which to change or drop. Apply the answers to the copy's
   `PREFERENCES.md` only: edit or delete the text, keep the remaining IDs unchanged. Never
   touch `RULES.md`. If the human has no changes, say so and leave the defaults.
6. Tell the human where the folder is and that an agent opening the project should read
   `.agents/AGENTS.md` and run the pickup procedure of `wax_handoff` first; it quotes the
   genesis entry, which asks for a brief exploration before any work. Do not write a handoff
   entry in the new project; its first real session does that.

## Procedure: check

1. Run `scripts/check.sh <project-or-.agents-path>`. With no argument it checks the current
   directory.
2. Report the `ok` and `FAIL` lines. On any `FAIL`, do not fix anything; the human decides
   what to repair (R-09). The most common repairs are listed in the refusals table below.

## What setup changes in the copy

| Item | In the reference | In the new copy |
|---|---|---|
| `AGENTS.md` title | `<project>` placeholder | the project name |
| `handoffs/handoffs/` | template plus the genesis entry | the same, project name filled in |
| `handoffs/HANDOFF.md` | genesis head, Entries 1 | unchanged |
| `PREFERENCES.md` | shipped defaults | the human's choices from step 5 |
| `.git/` | present when cloned | removed |
| Everything else | — | byte-identical |

## Refusals

| Condition | Message | What the human does |
|---|---|---|
| `<target>/.agents` already exists | `FAIL: … already exists; run check.sh on it instead` | Run `check`, or move the old folder away first. |
| Target is inside the reference `.agents` | `FAIL: target … is inside the reference .agents` | Give a project path outside this folder. |
| Source is not an `.agents` reference | `FAIL: … is not an .agents reference` | Run the script from a clone of the reference, or pass `--source`. |
| `check` reports a HANDOFF.md mismatch | `FAIL  HEAD is …` or `FAIL  Entries is …` | Fix `HANDOFF.md` by hand to match the files, re-run `check`. |
| `check` reports a skill with bad frontmatter | `FAIL  <name> frontmatter keys are …` | Make the frontmatter exactly `name` and `description` (R-12). |

## Files

- `scripts/setup.sh` — copies, names, then checks. Usage: `setup.sh [target] [--name N] [--source S]`.
- `scripts/check.sh` — read-only structural and handoff checks. Usage: `check.sh [path]`. Exit 1 on failure.
