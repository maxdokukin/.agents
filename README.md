# .agents — reference design

For humans. Agents read `AGENTS.md` instead and are told not to open this file (R-02).

## Summary

A self-contained folder that gives a coding agent **boundaries** (rules), **context** (a
record of past sessions), and **tools** (skills). Plain markdown, a fixed layout, a few
invariants. Copy it into any project as-is.

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

1. `cp -r .agents <project>/.agents`
2. Replace `<project>` in the title of `AGENTS.md`.
3. Keep the sample entry in `handoffs/handoffs/` as a worked example, or delete it and reset
   `HANDOFF.md` to the zero-entry block in
   `skill/skillset/xewe_handoff/references/formats.md`.
4. Point the agent at `AGENTS.md`. Its first action is the `pickup` procedure of
   `xewe_handoff`; its last is `handoff`.

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
      sample_skill/               reference anatomy: SKILL.md, scripts/, references/, assets/, evals/
```

### Session lifecycle

```
AGENTS.md → RULES.md → xewe_handoff pickup (validate, open HEAD, quote exit point) → SKILL.md
    → work → xewe_handoff handoff (copy template, fill, write <utc-stamp>.md, advance HEAD)
```

### Conventions

| Convention | Rule |
|---|---|
| Timestamps | UTC. Entry filenames `yyyy-mm-dd-hh-mm-ss.md`; HEAD is the lexically greatest one, so text order is time order. |
| Integrity | `xewe_handoff` validates HEAD, count, index, template, and entry shape before every read or write, and stops rather than repairs on mismatch (R-11). |
| Skills | Folder named after the skill; `SKILL.md` frontmatter has only `name` and `description`; detail goes in `references/`, `scripts/`, `assets/`, `evals/` (R-14). |
| Rule IDs | Stable forever; append, never renumber. `grep -rohE 'R-[0-9]{2}' .agents \| sort -u` lists every citation. |
| Paths | Relative to `.agents/` or the project root, so the folder stays portable (R-20). |
