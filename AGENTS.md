# AGENTS.md — <project>

This folder is the agentic part of the project. It gives you boundaries, context, and tools,
in that order. Read it as described below before doing anything else in the repository.

## Read in this order

1. **`RULES.md` — boundaries.** Enumerated rules that apply without exception. Cite them by
   ID when you explain a decision or a refusal.
2. **`handoffs/HANDOFF.md` — context.** The head of the work record: where the last session
   stopped and what is open. Reach it only through the `pickup` procedure of the
   `xewe_handoff` skill (R-05), because the directory has invariants that the skill checks
   before you rely on anything in it.
3. **`skill/SKILL.md` — tools.** The only index of skills (R-12). Pick skills from its table,
   never by browsing `skill/skillset/`.

## Do not read README.md

- **`README.md` is for humans.** It holds rationale and history and repeats nothing you need.
  Do not open, grep, or summarize it (R-02). The files above are your only source of truth.

## Session shape

- **Pickup → work → handoff.** Start with `xewe_handoff` pickup, do the work, end with
  `xewe_handoff` handoff. A session that changed anything and did not end with a handoff is
  incomplete (R-07); say so rather than letting it pass.

## Never do these without being asked

- **Edit `RULES.md` or this file** (R-18). Propose changes in the handoff instead (R-24).
- **Touch anything under `handoffs/` by hand** (R-05). The skill is the only door.
- **Add, rename, or remove a top-level item in `.agents/`** (R-17).
- **Commit, push, tag, release, publish, or delete what you did not create** (R-23).

## Precedence

- **Human instruction in this session > `RULES.md` > this file > `skill/SKILL.md` > a skill**
  (R-04). A project's own `.agents/` wins over any organization-level agent file. Record every
  human-instructed deviation in the handoff, quoting the instruction.

## Reporting back

- **Say what you actually ran** and label anything unverified as unverified (R-21).
- **Never report a skipped or failed step as done** (R-22). Failures come with their output.
