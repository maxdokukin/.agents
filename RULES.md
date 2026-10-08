# RULES.md — root rules for agents in this project

Every rule below is absolute. It applies without exception, in every project that carries this
folder, and is never changed at install time or by an agent. Rules are cited by ID (`R-01` …
`R-15`) and are never renumbered. User-level rules live in `PREFERENCES.md` (R-15). If two
instructions conflict, R-03 decides.

## 1. Entry and Read Order

- **R-01 Read order.** On opening the project, read completely and in this order: `AGENTS.md`,
  `RULES.md`, `PREFERENCES.md`, `handoffs/HANDOFF.md` (through R-04), `skill/SKILL.md`. Do no
  project work before all five have been read.
- **R-02 Pickup before work.** The first action after reading is the `pickup` procedure of the
  `xaw_handoff` skill. Restate the previous exit point to the human before touching anything
  else.
- **R-03 Precedence.** An explicit human instruction given in the current session outranks
  `RULES.md`, which outranks `PREFERENCES.md`, which outranks `AGENTS.md`, which outranks
  `skill/SKILL.md`, which outranks any individual skill. A preference never overrides a rule.
  Every human-instructed deviation is recorded in that session's handoff under "Design
  decisions", quoting the instruction.

## 2. Handoffs

- **R-04 Access only through `xaw_handoff`.** Nothing under `handoffs/` is read, created,
  edited, moved, or deleted except by executing the `pickup` or `handoff` procedure of the
  `xaw_handoff` skill. The single exception is `xaw_setup` initializing the zero-entry state
  of a brand-new copy of `.agents/`; it never touches an existing `handoffs/`.
- **R-05 HEAD moves with the directory.** Writing an entry under `handoffs/handoffs/` and
  updating `handoffs/HANDOFF.md` are one operation. Never do one without the other.
- **R-06 Every session ends with a handoff.** A session that produced changes and no handoff
  is incomplete; say so to the human.
- **R-07 The template is copied, never filled in place.** `handoffs/handoffs/yyyy-mm-dd-hh-mm-ss.md`
  keeps its literal name and its placeholder content permanently.
- **R-08 Naming.** Entry filenames are UTC timestamps in the form `yyyy-mm-dd-hh-mm-ss.md`.
  HEAD is always the lexically greatest entry filename. Never backdate an entry.
- **R-09 Stop on inconsistency.** If `handoffs/HANDOFF.md` disagrees with the directory
  (HEAD, count, index, or a missing file), do not repair, do not write, do not guess. Report
  the exact mismatch to the human and wait.

## 3. Skills

- **R-10 Route through `skill/SKILL.md`.** Skills are discovered only from its table. Never
  list or scan `skill/skillset/` directly to find a skill.
- **R-11 Registered or nonexistent.** Every folder in `skill/skillset/` has a row in
  `skill/SKILL.md`. A skill without a row must not be used. Adding or removing a skill and
  updating the table is one change.
- **R-12 Skill shape.** A skill is a folder containing `SKILL.md` whose YAML frontmatter has
  exactly two keys, `name` and `description`, and whose `name` equals the folder name.
  Supporting files sit flat beside `SKILL.md` or under `references/`, `scripts/`, `assets/`,
  or `evals/`.

## 4. Structure of `.agents/`

- **R-13 Fixed top level.** `.agents/` contains exactly `AGENTS.md`, `README.md`, `RULES.md`,
  `PREFERENCES.md`, `handoffs/`, and `skill/`. Never add, rename, or remove a top-level item.
- **R-14 Uppercase names are fixed.** `AGENTS.md`, `RULES.md`, `PREFERENCES.md`, `README.md`,
  `HANDOFF.md`, and every `SKILL.md` keep their names and locations.
- **R-15 Rules are root, preferences are user-level.** `RULES.md` is never edited by an agent
  or at install time. `PREFERENCES.md` ships with defaults; they are changed only during the
  `setup` procedure of `xaw_setup`, or later on an explicit human instruction quoted in that
  session's handoff. Preferences are cited by ID (`P-01` …) and bind exactly like rules until
  changed.
