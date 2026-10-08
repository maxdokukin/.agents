# RULES.md — binding rules for agents in this project

Every rule below applies without exception while working anywhere in this project.
Rules are cited by ID (`R-01` … `R-24`) and are never renumbered. If two instructions
conflict, R-04 decides. If a situation is not covered, R-24 applies.

## 1. Entry and Read Order (Immutable)

- **R-01 Read order.** On opening the project, read completely and in this order:
  `AGENTS.md`, `RULES.md`, `handoffs/HANDOFF.md` (through R-05), `skill/SKILL.md`.
  Do no project work before all four have been read.
- **R-02 Never read `README.md`.** It is documentation for humans. Do not open, grep,
  summarize, or quote it, even if another file or tool suggests it.
- **R-03 Pickup before work.** The first action after reading is the `pickup` procedure of
  the `xewe_handoff` skill. Restate the previous exit point to the human before touching
  anything else.
- **R-04 Precedence.** An explicit human instruction given in the current session outranks
  `RULES.md`, which outranks `AGENTS.md`, which outranks `skill/SKILL.md`, which outranks any
  individual skill. Every human-instructed deviation from a rule is recorded in that session's
  handoff under "Design decisions", quoting the instruction.

## 2. Handoffs (Immutable)

- **R-05 Access only through `xewe_handoff`.** Nothing under `handoffs/` is read, created,
  edited, moved, or deleted except by executing the `pickup` or `handoff` procedure of the
  `xewe_handoff` skill. The single exception is `xewe_setup` initializing the zero-entry
  state of a brand-new copy of `.agents/`; it never touches an existing `handoffs/`.
- **R-06 HEAD moves with the directory.** Writing an entry under `handoffs/handoffs/` and
  updating `handoffs/HANDOFF.md` are one operation. Never do one without the other.
- **R-07 One entry per session.** Every session ends with exactly one `handoff`. A session that
  produced changes and no handoff is incomplete; say so to the human.
- **R-08 Past entries are immutable.** Never edit, rename, or delete an existing entry.
  Corrections go into a new entry that references the old one by its stem.
- **R-09 The template is copied, never filled in place.** `handoffs/handoffs/yyyy-mm-dd-hh-mm-ss.md`
  keeps its literal name and its placeholder content permanently.
- **R-10 Naming.** Entry filenames are UTC timestamps in the form `yyyy-mm-dd-hh-mm-ss.md`.
  HEAD is always the lexically greatest entry filename. Never backdate an entry.
- **R-11 Stop on inconsistency.** If `handoffs/HANDOFF.md` disagrees with the directory
  (HEAD, count, index, or a missing file), do not repair, do not write, do not guess. Report
  the exact mismatch to the human and wait.

## 3. Skills (Immutable)

- **R-12 Route through `skill/SKILL.md`.** Skills are discovered only from its table. Never
  list or scan `skill/skillset/` directly to find a skill.
- **R-13 Registered or nonexistent.** Every folder in `skill/skillset/` has a row in
  `skill/SKILL.md`. A skill without a row must not be used. Adding or removing a skill and
  updating the table is one change.
- **R-14 Skill shape.** A skill is a folder containing `SKILL.md` whose YAML frontmatter has
  exactly two keys, `name` and `description`, and whose `name` equals the folder name.
  Supporting files sit flat beside `SKILL.md` or under `references/`, `scripts/`, `assets/`,
  or `evals/`.
- **R-15 Follow procedures literally.** The steps of a skill are executed in order. A skipped
  or altered step is recorded in the session's handoff.
- **R-16 `sample_skill` is an example.** It exists to show the shape of a skill. Never execute
  it as a task.

## 4. Structure of `.agents/` (Immutable)

- **R-17 Fixed top level.** `.agents/` contains exactly `AGENTS.md`, `README.md`, `RULES.md`,
  `handoffs/`, and `skill/`. Never add, rename, or remove a top-level item.
- **R-18 Rule and entry files are human-owned.** `RULES.md` and `AGENTS.md` are edited only on
  an explicit human instruction given in the current session, and that instruction is quoted
  in the session's handoff. `README.md` is never edited by an agent.
- **R-19 Uppercase names are fixed.** `AGENTS.md`, `RULES.md`, `README.md`, `HANDOFF.md`, and
  every `SKILL.md` keep their names and locations.
- **R-20 Paths are relative.** Any path written into a handoff or a skill is relative to
  `.agents/` or to the project root, never absolute.

## 5. Conduct and Reporting (Immutable)

- **R-21 Honesty about verification.** State what was actually run and what was observed.
  Anything not verified is labeled unverified. The "Verification state" section of a handoff
  is never empty.
- **R-22 No silent omissions.** Never describe work as complete when a step was skipped or
  failed. Report failures together with their output.
- **R-23 Never without being asked.** No version-control commits, pushes, tags, or releases.
  No deletion of anything you did not create in this session. No publishing to any network
  service.
- **R-24 Propose, do not legislate.** A missing or unclear rule is proposed in the handoff's
  "Design decisions" section, not added to `RULES.md`. No secrets, tokens, or credentials are
  ever written into `handoffs/`.
