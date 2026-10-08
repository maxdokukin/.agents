# WAX Agentic Workspace

Version **WAX 1.0**. The name is XAW (XeWe Agentic Workspace) read backwards: WAX makes the
agentic experience smooth. `AGENTS.md` carries the same version string, and `check.sh` fails
when the two disagree.

For humans. Agents read `AGENTS.md` instead and are told not to open this file (P-01).

## Summary

WAX is a self-contained `.agents/` folder that gives a coding agent **boundaries** (rules),
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

- **Boundaries: `RULES.md` and `PREFERENCES.md`.** Rules R-01 to R-15 are root: absolute,
  identical in every project, never edited. Preferences P-01 to P-10 are user-level: shipped
  defaults that `wax_setup` lets you change at install time (R-15). Both are cited by ID.
- **Context: `handoffs/`.** Every session begins by picking up the newest entry and ends by
  writing a new one. An entry records work done, files touched, decisions, open threads, and
  a four-key exit point the next session reads mechanically. `HANDOFF.md` is the head node:
  HEAD, status, index. One skill, `wax_handoff`, is the only door into the directory.
- **Tools: `skill/`.** `SKILL.md` is the router (a "you want to… / read" table plus a
  registry); skills live one level down as folders. `sample_skill` shows the full anatomy
  Anthropic recommends and is never run.

Two files are routers, `handoffs/HANDOFF.md` and `skill/SKILL.md`. They point; content lives
below them, and each is updated in the same change as its directory, so reading the router is
enough to know the state of the directory.

## How to use

1. Clone this repository, or open a project that already contains it. The public repository
   ships in the same state setup produces, so a bare clone into `<project>/.agents` also
   works; only the project name in `AGENTS.md` is left for you to fill.
2. Run the setup script against the target project:
   ```
   .agents/skill/skillset/wax_setup/scripts/setup.sh <project-dir> --name <project>
   ```
   Or ask an agent to run the `setup` procedure of `wax_setup`. Either way the script copies
   the folder, strips git metadata, fills the project name in `AGENTS.md`, seeds `handoffs/`
   with a single genesis entry, and verifies the result. It refuses to overwrite an existing
   `.agents/`. The genesis entry is the first HEAD: its exit point tells the first session to
   explore the project briefly and report back before doing any work, so no project ever
   starts from another project's history.
3. Point the agent at `<project>/.agents/AGENTS.md`. Its first action is the `pickup`
   procedure of `wax_handoff`; its last is `handoff`.
4. `PREFERENCES.md` in the copy is yours. The `setup` procedure walks through it; edit it
   later by hand whenever the project's policy changes. `RULES.md` stays as shipped.
5. Later, `wax_setup/scripts/check.sh <project-dir>` verifies a copy without changing it.

### Developing the reference

The reference is developed in a private repository (`.agents-wd`) that keeps its own handoff
history, like any project. The public repository is an export of it: run
`skill/skillset/wax_setup/scripts/publish.sh <public-clone>` from the private tree, review the
diff, commit, push. The export carries no history, only the genesis entry, so what you clone
is exactly what setup produces.

To add a skill, copy `skill/skillset/sample_skill/assets/skill-template.md` into a new folder,
run `sample_skill/scripts/check_frontmatter.sh` on it, and add it to `skill/SKILL.md` in the
same change (R-11).

## Details

### File layout

```
.agents/
  AGENTS.md                       agent entry point: read order, boundaries, session shape
  README.md                       this file
  RULES.md                        root rules R-01 … R-15, absolute
  PREFERENCES.md                  user preferences P-01 … P-10, changed at setup
  handoffs/
    HANDOFF.md                    head node: HEAD, status, index
    handoffs/
      yyyy-mm-dd-hh-mm-ss.md      blank entry template, literal name, never edited
      <utc-stamp>.md              one immutable entry per session
  skill/
    SKILL.md                      router: the only index of skills
    skillset/
      wax_handoff/                owns handoffs/: pickup, handoff, formats reference
      wax_setup/                  creates .agents/ in a project: setup, check; publish for maintainers
        assets/genesis.md         the first entry every fresh copy starts from
      sample_skill/               reference anatomy: SKILL.md, scripts/, references/, assets/, evals/
```

### Session lifecycle

```
open project
  └─ AGENTS.md            read order, boundaries
       ├─ RULES.md        root rules, absolute
       ├─ PREFERENCES.md  user rules, set during wax_setup
       ├─ HANDOFF.md      via wax_handoff pickup: validate, open HEAD, quote exit point
       └─ SKILL.md        pick tools
            │
            ▼
          work            project tasks, skills as needed
            │
            ▼
  wax_handoff handoff    copy template → fill → write <utc-stamp>.md → advance HEAD
```

### Conventions

| Convention | Rule |
|---|---|
| Timestamps | UTC. Entry filenames `yyyy-mm-dd-hh-mm-ss.md`; HEAD is the lexically greatest one, so text order is time order. |
| Integrity | `wax_handoff` validates HEAD, count, index, template, and entry shape before every read or write, and stops rather than repairs on mismatch (R-09). |
| Skills | Folder named after the skill; `SKILL.md` frontmatter has only `name` and `description`; detail goes in `references/`, `scripts/`, `assets/`, `evals/` (R-12). |
| Rule IDs | `R-NN` in RULES.md, `P-NN` in PREFERENCES.md. Stable forever; append, never renumber. `grep -rohE '[RP]-[0-9]{2}' .agents \| sort -u` lists every citation. |
| Paths | Relative to `.agents/` or the project root, so the folder stays portable (P-06). |
