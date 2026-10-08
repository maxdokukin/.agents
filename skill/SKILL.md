# Skills

Every skill available in this project is listed here. Nothing else under `skillset/` exists
for you: discover skills from this table only (R-12), and never use a skill that has no row
(R-13). This file is a router. The skills themselves live one level down.

## Pick a skill

| You want to… | Read |
|---|---|
| start a session: find where the last session stopped and what is open | [skillset/xewe_handoff/SKILL.md](skillset/xewe_handoff/SKILL.md), procedure `pickup` |
| end a session: record work, decisions, and where to resume | [skillset/xewe_handoff/SKILL.md](skillset/xewe_handoff/SKILL.md), procedure `handoff` |
| set up `.agents/` in a project, or check an existing one | [skillset/xewe_setup/SKILL.md](skillset/xewe_setup/SKILL.md), procedures `setup` and `check` |
| write or review a skill: see the full anatomy of one (example only, never run as a task) | [skillset/sample_skill/SKILL.md](skillset/sample_skill/SKILL.md) |

Every session: `xewe_handoff` pickup first, `xewe_handoff` handoff last. Everything in
between is project work.

## Registry

- **xewe_handoff** — procedures: pickup, handoff — owns: handoffs/ — files: SKILL.md, references/formats.md
- **xewe_setup** — procedures: setup, check — owns: nothing (creates a new copy of .agents/) — files: SKILL.md, scripts/setup.sh, scripts/check.sh
- **sample_skill** — reference example, no procedures to run — owns: nothing — files: SKILL.md, scripts/check_frontmatter.sh, references/example-reference.md, assets/skill-template.md, evals/evals.json

## Adding a skill

1. Create `skillset/<name>/SKILL.md` with frontmatter `name: <name>` and a folded
   `description` (R-14). Copy `skillset/sample_skill/assets/skill-template.md` to start, and run
   `skillset/sample_skill/scripts/check_frontmatter.sh <folder>` before registering.
2. Add a row to "Pick a skill" and a line to "Registry" above.
3. Do both in the same change (R-13).
