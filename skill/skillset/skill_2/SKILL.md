---
name: skill_2
description: >
  Reference example of a skill in this project. Shows the folder layout, the frontmatter, and
  the section order every skill follows. Use when writing or reviewing a skill; never run it as
  a task (R-16). Triggers: "new skill", "skill format", "what does a skill look like", skill
  template.
---

# skill_2 (reference example)

This skill does nothing. It exists so that the shape of a skill can be copied. Do not execute
its procedure as project work (R-16).

## Anatomy of a skill

- **One folder per skill** under `skill/skillset/`. The folder name is the skill name.
- **`SKILL.md` is required.** Its YAML frontmatter has exactly two keys: `name`, which equals
  the folder name, and a folded `description` that says what the skill does, when to use it
  ("Use when …"), and the words that should trigger it ("Triggers: …") (R-14).
- **Supporting files are optional.** Put long facts and formats under `references/`, runnable
  helpers under `scripts/`, or small files flat beside `SKILL.md`.
- **Paths are relative** to `.agents/` or to the project root (R-20).

## Section order every skill uses

1. **Title and intro.** What the skill owns and which rules it cites. Two or three lines.
2. **Invariants or preconditions.** What must be true before and after the skill runs. These
   make the refusals below predictable.
3. **Procedures.** Numbered steps, one action per step, executed in order (R-15). A skill with
   several procedures names each one (for example `pickup` and `handoff`).
4. **Refusals.** A table of condition, message, and what the human does next. A skill that
   knows when to stop is safer than one that guesses.
5. **Files.** Every supporting file, with one line on what it holds.

## Example procedure: example

1. Cite the rule that governs this action, for example R-15, so the human can check it.
2. Read `references/example-reference.md` for the exact format you are about to produce.
3. Perform the single action the step describes. Do not combine steps.
4. Verify the result with a command or a check you can name, and record it in the session's
   handoff under "Verification state" (R-21).

## Refusals

| Condition | Message | What the human does |
|---|---|---|
| Asked to run skill_2 as a task | `Refused: skill_2 is a reference example (R-16).` | Pick a real skill from skill/SKILL.md. |

## Registering it

A skill exists only when `skill/SKILL.md` lists it. Add a row to its "Pick a skill" table and
a line to its "Registry" in the same change that creates the folder (R-13).

## Files

- `references/example-reference.md` — shows what a reference file is for and how it is linked.
