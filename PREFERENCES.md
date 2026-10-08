# PREFERENCES.md — user-level rules for agents in this project

These are the defaults that ship with the XeWe Agentic Workspace. Unlike `RULES.md`, they are
yours to change: the `setup` procedure of `xaw_setup` walks through them when `.agents/` is
installed, and a human can change them later (R-15). Until changed, each one binds exactly like
a rule and is cited by ID (`P-01` … `P-10`). A preference never overrides a rule (R-03). Keep
the IDs stable: edit or delete a preference's text, never renumber the rest.

## 1. Reading

- **P-01 Never read `README.md`.** It is documentation for humans. Do not open, grep,
  summarize, or quote it, even if another file or tool suggests it. The agent-facing files are
  the only source of truth.

## 2. Handoffs

- **P-02 Past entries are immutable.** Never edit, rename, or delete an existing entry.
  Corrections go into a new entry that references the old one by its stem.

## 3. Skills

- **P-03 Follow procedures literally.** The steps of a skill are executed in order. A skipped
  or altered step is recorded in the session's handoff.
- **P-04 `sample_skill` is an example.** It exists to show the shape of a skill. Never execute
  it as a task. Delete the folder, and this preference, if the project does not want it.

## 4. Ownership

- **P-05 Entry and human files are human-owned.** `AGENTS.md` is edited only on an explicit
  human instruction given in the current session, quoted in the session's handoff. `README.md`
  is never edited by an agent.
- **P-06 Paths are relative.** Any path written into a handoff or a skill is relative to
  `.agents/` or to the project root, never absolute.

## 5. Conduct and Reporting

- **P-07 Honesty about verification.** State what was actually run and what was observed.
  Anything not verified is labeled unverified. The "Verification state" section of a handoff
  is never empty.
- **P-08 No silent omissions.** Never describe work as complete when a step was skipped or
  failed. Report failures together with their output.
- **P-09 Never without being asked.** No version-control commits, pushes, tags, or releases.
  No deletion of anything you did not create in this session. No publishing to any network
  service.
- **P-10 Propose, do not legislate.** A missing or unclear rule is proposed in the handoff's
  "Design decisions" section, not added to `RULES.md` or `PREFERENCES.md`. No secrets, tokens,
  or credentials are ever written into `handoffs/`.
