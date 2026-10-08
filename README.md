# .agents — reference design

A self-contained folder that gives a coding agent what it needs to work inside a project:
**boundaries** (rules), **context** (the record of previous sessions), and **tools** (skills).
It is meant to be copied into any project as-is. It does not depend on a particular agent
framework; it is plain markdown with a fixed layout and a few invariants.

## Agents do not read this file

`AGENTS.md` is the agent's entry point and tells agents not to open this file (rule R-02).
This document explains *why* the design is the way it is, carries history and rationale, and
is written for people. Loading it into an agent's context would cost tokens and risk
contradicting the agent-facing files, which are the only source of truth for agents. If
something in here matters to an agent, it belongs in `AGENTS.md`, `RULES.md`, or a skill.

## Layout

```
.agents/
  AGENTS.md                       agent entry point: read order, boundaries, session shape
  README.md                       this file, for humans only
  RULES.md                        enumerated rules R-01 … R-24, no exceptions
  handoffs/
    HANDOFF.md                    head node: HEAD, directory status, index
    handoffs/
      yyyy-mm-dd-hh-mm-ss.md      blank entry template, literal name, never edited
      2026-10-07-21-10-00.md      sample entry: the session that created this design
  skill/
    SKILL.md                      head node: the only index of skills
    skillset/
      xewe_handoff/               the skill that owns handoffs/
        SKILL.md
        references/formats.md
      skill_2/                    reference skill, shows the shape, never run
        SKILL.md
        references/example-reference.md
```

## The three parts

**Boundaries: `RULES.md`.** A formal, enumerated ruleset. Every rule has a stable ID and is
absolute. Absolute rules can be cited instead of debated, which keeps agent reasoning short
and refusals predictable. The only flexibility is explicit: rule R-04 puts a human instruction
in the current session above the rules, and rule R-24 lets an agent propose a rule in a
handoff rather than add one.

**Context: `handoffs/`.** Each work session has an entry point and an exit point, and both are
the handoff directory. A session starts by picking up the newest entry and ends by writing a
new one. An entry records the work done, files read and written, design decisions,
philosophical choices, open threads, and a mechanical exit point. Handoffs are the project's
memory; chat history is not.

**Tools: `skill/`.** Skills are procedures an agent follows. `skill/SKILL.md` is the router: a
table of "you want to … / read …" rows plus a registry. A skill that is not in the table does
not exist for the agent.

## Session lifecycle

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

## File by file

**`AGENTS.md`.** Short and prescriptive, one reason per bullet. It routes to the three other
files, forbids reading this README, states the session shape, lists what never happens
unasked, and fixes precedence. It cites rules by ID and never restates them. The
`<project>` placeholder in its title is replaced when the folder is copied.

**`RULES.md`.** Five sections: entry and read order, handoffs, skills, structure of `.agents/`,
conduct and reporting. IDs run R-01 to R-24 and are never renumbered, because other files cite
them. Only humans edit this file (R-18).

**`handoffs/HANDOFF.md`.** The head node. Its first line is an "Updated … UTC" stamp. The
head block has six fields: HEAD, HEAD timestamp, Entries, Last writer, Integrity, Status. Then
an index with one row per entry, newest first, and a pointer to the template. It holds no
session content. Only the `xewe_handoff` skill writes it, and it is rewritten every time the
directory changes, so it is always in step with the files (R-06).

**`handoffs/handoffs/yyyy-mm-dd-hh-mm-ss.md`.** The blank template, kept under its literal
name. The skill copies it; nobody edits it (R-09). Ten numbered sections. Section 9, the exit
point, has exactly four keys (Resume at, State, First action, Blocked on) so the next session
can consume it mechanically.

**`handoffs/handoffs/<stamp>.md`.** One entry per session. Immutable once written (R-08);
corrections are new entries that reference the old one. The sample entry
`2026-10-07-21-10-00.md` records the session that produced this folder, including the
decisions behind it.

**`skill/SKILL.md`.** The router. "Pick a skill" table, one line on order (pickup first,
handoff last), a registry with one line per skill folder, and the three-step recipe for adding
a skill.

**`skill/skillset/xewe_handoff/`.** The only door into `handoffs/`. Two procedures share one
validation step with seven checks (head keys present, HEAD is newest, count matches, index and
files agree, template intact, HEAD entry well-formed). `pickup` reads and prints; `handoff`
derives a UTC stem, copies the template, fills it, self-checks, rewrites `HANDOFF.md`, and
validates again. On any inconsistency the skill stops and reports instead of repairing (R-11).
`references/formats.md` holds the exact field formats and the zero-entry head block.

**`skill/skillset/skill_2/`.** A reference skill. It shows the frontmatter, the folder layout,
and the section order (intro, invariants, procedures, refusals, files). It is never executed
as a task (R-16). Copy its shape when writing a real skill.

## Conventions

| Convention | Rule |
|---|---|
| Timestamps | UTC everywhere. Entry filenames `yyyy-mm-dd-hh-mm-ss.md` from `date -u +%Y-%m-%d-%H-%M-%S`. Human form `2026-10-07 21:10:00 UTC`. |
| Entry regex | `^[0-9]{4}(-[0-9]{2}){5}\.md$`. The template does not match it and is never counted. |
| HEAD | The lexically greatest entry filename. Text sort order is time order, so no parsing is needed. |
| Fixed filenames | `AGENTS.md`, `README.md`, `RULES.md`, `HANDOFF.md`, `SKILL.md` keep their uppercase names and locations (R-19). |
| Skill format | Folder named after the skill, `SKILL.md` with frontmatter `name` and `description` only, support files under `references/` or `scripts/` (R-14). |
| Rule IDs | `R-NN`, stable forever. To find every citation: `grep -rohE 'R-[0-9]{2}' .agents \| sort -u`. |
| Paths | Written relative to `.agents/` or the project root, never absolute, so the folder stays portable (R-20). |

## Head nodes versus content

Two files are routers: `handoffs/HANDOFF.md` and `skill/SKILL.md`. They point; they do not
carry. Content lives one level down, in entry files and skill folders. A router is always
updated in the same change as its directory, so reading the router is enough to know the
state of the directory. This keeps the files an agent must read on every session start small,
and makes consistency something that can be checked in a few lines.

## Using it in a project

1. Copy the folder: `cp -r .agents <project>/.agents`.
2. Replace `<project>` in the title of `AGENTS.md`.
3. Decide what to do with the sample entry. Either keep it as a worked example, or delete
   `handoffs/handoffs/2026-10-07-21-10-00.md` and replace the head block in
   `handoffs/HANDOFF.md` with the zero-entry block from
   `skill/skillset/xewe_handoff/references/formats.md`.
4. Point the agent at `AGENTS.md`. The first thing it should do is run the pickup procedure.

## Adding a skill

Create `skill/skillset/<name>/SKILL.md` with the two-key frontmatter, add a row to the "Pick a
skill" table and a line to the registry in `skill/SKILL.md`, and do both in one change (R-13).
Use `skill_2` as the pattern. If the skill owns a directory the way `xewe_handoff` owns
`handoffs/`, say so in the registry line.

## Changing the rules

Only a human edits `RULES.md` or `AGENTS.md` (R-18). Agents propose changes in the "Design
decisions" section of their handoff (R-24); the human reads the handoff and decides. Never
renumber an existing rule; append new ones. Rule IDs are cited across the folder.

## Verification checklist

Run these from the parent of `.agents/` after any structural change.

1. The tree matches the Layout section: `find .agents | sort`. No `skill_1`, no empty files
   (`find .agents -type f -empty` prints nothing).
2. HEAD in `HANDOFF.md` equals the newest entry file:
   `ls .agents/handoffs/handoffs | grep -E '^[0-9]{4}(-[0-9]{2}){5}\.md$' | sort | tail -1`.
   `Entries` equals the count from the same listing.
3. The template still contains `<yyyy-mm-dd-hh-mm-ss>`; the newest entry contains no `<`
   placeholders outside code spans.
4. Each entry has the four section 9 keys:
   `grep -cE '^- \*\*(Resume at|State|First action|Blocked on):\*\*' <entry>` prints 4.
5. Every folder in `skill/skillset/` appears in `skill/SKILL.md`, and each `SKILL.md`
   frontmatter has only `name` (equal to the folder) and `description`.
6. Every markdown link target resolves relative to its file.
7. Every cited rule ID exists: `grep -rohE 'R-[0-9]{2}' .agents | sort -u` is a subset of
   R-01 to R-24.
8. `AGENTS.md` says not to read `README.md` and does not link to it; no skill file mentions
   `README.md`.
