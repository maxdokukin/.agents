# XeWe Agentic Workspace (XAW)

For humans. Agents read `AGENTS.md` instead and are told not to open this file (R-02).

## Summary

XAW is a self-contained `.agents/` folder that gives a coding agent **boundaries** (rules),
**context** (a record of past sessions), and **tools** (skills). Plain markdown, a fixed
layout, a few invariants. Copy it into any project as-is. This repository is the reference
design.

## Problem

An agent opening a project knows nothing about what the last session did, what must never be
done, or which procedures exist. Chat history does not carry over, ad-hoc notes drift, and
instructions scattered through a repo get skipped. Each session starts cold and ends without
leaving a trace the next one can use.

## Solution

Three parts, each with a single entry file:

- **Boundaries: `RULES.md`.** Enumerated rules R-01 to R-24, absolute, cited by ID. Only
  humans edit them; agents propose changes in a handoff (R-18, R-24).
- **Context: `handoffs/`.** Every session begins by picking up the newest entry and ends by
  writing a new one. An entry records work done, files touched, decisions, open threads, and
  a four-key exit point the next session reads mechanically. `HANDOFF.md` is the head node:
  HEAD, status, index. One skill, `xewe_handoff`, is the only door into the directory.
- **Tools: `skill/`.** `SKILL.md` is the router (a "you want to… / read" table plus a
  registry); skills live one level down as folders. `sample_skill` shows the full anatomy
  Anthropic recommends and is never run.

Two files are routers, `handoffs/HANDOFF.md` and `skill/SKILL.md`. They point; content lives
below them, and each is updated in the same change as its directory, so reading the router is
enough to know the state of the directory.

## How to use

1. Clone this repository, or open a project that already contains it.
2. Run the setup script against the target project:
   ```
   .agents/skill/skillset/xewe_setup/scripts/setup.sh <project-dir> --name <project>
   ```
   Or ask an agent to run the `setup` procedure of `xewe_setup`. Either way the script copies
   the folder, strips git metadata, resets `handoffs/` to the zero-entry state, fills the
   project name in `AGENTS.md`, and verifies the result. It refuses to overwrite an existing
   `.agents/`.
3. Point the agent at `<project>/.agents/AGENTS.md`. Its first action is the `pickup`
   procedure of `xewe_handoff`; its last is `handoff`.
4. Later, `xewe_setup/scripts/check.sh <project-dir>` verifies a copy without changing it.

To add a skill, copy `skill/skillset/sample_skill/assets/skill-template.md` into a new folder,
run `sample_skill/scripts/check_frontmatter.sh` on it, and add it to `skill/SKILL.md` in the
same change (R-13).

## Details

### File layout

```
.agents/
  AGENTS.md                       agent entry point: read order, boundaries, session shape
  README.md                       this file
  RULES.md                        rules R-01 … R-24
  handoffs/
    HANDOFF.md                    head node: HEAD, status, index
    handoffs/
      yyyy-mm-dd-hh-mm-ss.md      blank entry template, literal name, never edited
      <utc-stamp>.md              one immutable entry per session
  skill/
    SKILL.md                      router: the only index of skills
    skillset/
      xewe_handoff/               owns handoffs/: pickup, handoff, formats reference
      xewe_setup/                 creates .agents/ in a project: setup, check
      sample_skill/               reference anatomy: SKILL.md, scripts/, references/, assets/, evals/
```

### Session lifecycle

```
open project
  └─ AGENTS.md            read order, boundaries
       ├─ RULES.md        the 24 rules
       ├─ HANDOFF.md      via xewe_handoff pickup: validate, open HEAD, quote exit point
       └─ SKILL.md        pick tools
            │
            ▼
          work            project tasks, skills as needed
            │
            ▼
  xewe_handoff handoff    copy template → fill → write <utc-stamp>.md → advance HEAD
```

### Conventions

| Convention | Rule |
|---|---|
| Timestamps | UTC. Entry filenames `yyyy-mm-dd-hh-mm-ss.md`; HEAD is the lexically greatest one, so text order is time order. |
| Integrity | `xewe_handoff` validates HEAD, count, index, template, and entry shape before every read or write, and stops rather than repairs on mismatch (R-11). |
| Skills | Folder named after the skill; `SKILL.md` frontmatter has only `name` and `description`; detail goes in `references/`, `scripts/`, `assets/`, `evals/` (R-14). |
| Rule IDs | Stable forever; append, never renumber. `grep -rohE 'R-[0-9]{2}' .agents \| sort -u` lists every citation. |
| Paths | Relative to `.agents/` or the project root, so the folder stays portable (R-20). |
