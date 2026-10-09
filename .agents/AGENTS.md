# AGENTS.md — <project>

This is **WAX 1.3**, the WAX Agentic Workspace. The rules, preferences, and skills below belong
to this version. Human documentation lives at https://github.com/maxdokukin/wax_agents.

This folder is the agentic part of the project. It gives you boundaries, context, and tools,
in that order. Read it as described below before doing anything else in the repository.

## Read in this order

1. **`RULES.md` — root boundaries.** Absolute rules, the same in every project. Cite them by
   ID when you explain a decision or a refusal.
2. **`PREFERENCES.md` — user boundaries.** This project's chosen defaults (R-15). They bind
   like rules until a human changes them; cite them by ID too.
3. **`handoffs/HANDOFF.md` — context.** The head of the work record: where the last session
   stopped and what is open. Reach it only through the `pickup` procedure of the
   `wax_handoff` skill (R-04), because the directory has invariants that the skill checks
   before you rely on anything in it.
4. **`skills/` — tools.** One folder per skill, each with a `SKILL.md`. Discover them by
   reading the frontmatter of every `skills/*/SKILL.md` (R-10); a folder without a valid one
   is not a skill (R-11).

## Session shape

- **Pickup → work → handoff.** Start with `wax_handoff` pickup, do the work, end with
  `wax_handoff` handoff. A session that changed anything and did not end with a handoff is
  incomplete (R-06); say so rather than letting it pass.

## Never do these without being asked

- **Edit `RULES.md`, `PREFERENCES.md`, or this file** (R-15, P-05). Propose changes in the
  handoff instead (P-10).
- **Touch anything under `handoffs/` by hand** (R-04). The skill is the only door.
- **Add, rename, or remove a top-level item in `.agents/`** (R-13).
- **Commit, push, tag, release, publish, or delete what you did not create** (P-09).

## Precedence

- **Human instruction in this session > `RULES.md` > `PREFERENCES.md` > this file > a
  skill** (R-03). A project's own `.agents/` wins over any organization-level agent file. Record every
  human-instructed deviation in the handoff, quoting the instruction.

## Reporting back

- **Say what you actually ran** and label anything unverified as unverified (P-07).
- **Never report a skipped or failed step as done** (P-08). Failures come with their output.
