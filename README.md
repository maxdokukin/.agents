# WAX Agentic Workspace

Version **WAX 1.3**. The name is XAW (XeWe Agentic Workspace) read backwards: WAX makes the
agentic experience smooth. `AGENTS.md` carries the same version string.

For humans. Agents read `.agents/AGENTS.md`; this file is not part of what gets installed.

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
  defaults that `wax_init` lets you change at install time (R-15). Both are cited by ID.
- **Context: `handoffs/`.** Every session begins by picking up the newest entry and ends by
  writing a new one. An entry records work done, files touched, decisions, open threads, and
  a four-key exit point the next session reads mechanically, plus the identity and session id
  of the agent that wrote it. `HANDOFF.md` is the head node: HEAD, status, index, and a
  `Resume` line you can paste to reopen the session that wrote HEAD. One skill, `wax_handoff`, is the only door into the directory.
- **Tools: `skills/`.** One folder per skill, each with a `SKILL.md` whose frontmatter
  (`name`, `description`) is how it is found: the same layout Claude Code uses under
  `~/.claude/skills/`, so a skill folder copies between the two unchanged. `sample_skill`
  shows the full anatomy Anthropic recommends and is never run.

One file is a router, `handoffs/HANDOFF.md`. It points; content lives below it, and it is
updated in the same change as its directory, so reading it is enough to know the state of the
directory. Skills need no router: their frontmatter is the index.

## How to use

1. Copy this prompt to Claude Code to install the skills, once per machine:

   ```
   Install the WAX Agentic Workspace skills. Run exactly these commands and nothing else:
   if [ -d ~/.wax ]; then git -C ~/.wax pull --ff-only; else git clone --depth 1 https://github.com/maxdokukin/wax_agents ~/.wax; fi
   mkdir -p ~/.claude/skills
   ln -sfn ~/.wax/.agents/skills/wax_init ~/.claude/skills/wax_init
   ln -sfn ~/.wax/.agents/skills/wax_handoff ~/.claude/skills/wax_handoff
   Then tell me to start a new session so the skills are picked up.
   ```

   The same prompt updates an existing install.
2. Go to your project and run `/wax_init`. It copies `.agents/` into `<project>/.agents`,
   fills the project name, walks you through `PREFERENCES.md`, and verifies the result. If the
   project already has an `.agents/`, it explores it first and asks you to **merge** (keep the
   handoff history, your preferences, and your skills; foreign files move into `project/`) or
   **discard** (set it aside and install fresh). Nothing is deleted: the old folder becomes
   `.agents.old-<stamp>`.

From then on, every session in that project starts with `/wax_handoff` pickup and ends with
`/wax_handoff` handoff. The first pickup quotes the genesis entry that ships with this
repository: explore the project briefly and report back before doing any work, so no project
ever starts from another project's history. `RULES.md` stays as shipped; `PREFERENCES.md` is
yours to edit whenever the project's policy changes. `/wax_init check` verifies a copy later
without changing it.

To add a skill, copy `skills/sample_skill/assets/skill-template.md` into a new folder under
`skills/` and run `sample_skill/scripts/check_frontmatter.sh` on it. A valid frontmatter is the
whole registration (R-11).

## Details

### File layout

```
wax_agents/                       this repository: a project with nothing but its workspace
  README.md                       this file; not installed
  .agents/                        what /wax_init copies, byte for byte
    AGENTS.md                       agent entry point: read order, boundaries, session shape
    RULES.md                        root rules R-01 … R-15, absolute
    PREFERENCES.md                  user preferences P-01 … P-11, changed at setup
    handoffs/
      HANDOFF.md                    head node: HEAD, status, index
      handoffs/
        yyyy-mm-dd-hh-mm-ss.md      blank entry template, literal name, never edited
        <utc-stamp>.md              one immutable entry per session
    skills/                         one folder per skill; frontmatter is the index
      wax_handoff/                  owns handoffs/: pickup, handoff, formats reference
      wax_init/                     creates or upgrades .agents/: init (setup, migrate), check
      sample_skill/                 reference anatomy: SKILL.md, scripts/, references/, assets/, evals/
    project/                        optional: foreign content merged by wax_init, listed in P-11
```

### Session lifecycle

```
open project
  └─ AGENTS.md            read order, boundaries
       ├─ RULES.md        root rules, absolute
       ├─ PREFERENCES.md  user rules, set during wax_init
       ├─ HANDOFF.md      via wax_handoff pickup: validate, open HEAD, quote exit point
       └─ skills/         pick tools by frontmatter
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
