# Handoff <yyyy-mm-dd-hh-mm-ss>

<!-- Genesis entry. Seeded by wax_setup when the workspace is installed; it is the first
     entry of every fresh copy and is never written by an agent session. It exists so the
     first real session explores the project before it does any work. -->

## 1. Session metadata

- **Entry:** <yyyy-mm-dd-hh-mm-ss>
- **Title:** GENESIS: workspace installed, project not yet explored
- **Agent:** wax_setup (seeded by script, no agent session)
- **Human:** project owner
- **Previous HEAD:** none
- **Session status:** complete
- **Project:** <project>

## 2. Entry point (what was picked up)

Fresh project, no previous HEAD.

- **Human request:** Install the WAX Agentic Workspace (<version>) in this project.

## 3. Work done

- wax_setup copied the reference design into `.agents/` and seeded this entry.
- No project work was done. Nothing in this project has been read, explored, or changed.

## 4. Files read

- none

## 5. Files written

- .agents/ — created

## 6. Design decisions

- **Decision:** The first real session begins with a brief exploration of the project, not with work.
  **Why:** The agent knows nothing about this project yet. The handoff chain must start from an observed state, not an assumed one.
  **Alternatives rejected:** Starting from a task list written at install time (it would describe a project nobody has looked at).

## 7. Philosophical choices

- Never carry another project's history into this one. Every workspace starts from what the agent sees here.

## 8. Open threads / next steps

- [ ] Explore the project briefly: top-level layout, build and test entry points, the project's own README, open TODOs.
- [ ] Report the findings to the human and ask what to work on.
- [ ] Write the first real handoff at the end of that session.

## 9. Exit point

- **Resume at:** the project root, one level above `.agents/`
- **State:** <version> was just installed; nothing in this project has been explored or changed.
- **First action:** Explore the project briefly and report what you found to the human before doing any work.
- **Blocked on:** none

## 10. Verification state

| Claim | Verified by | Result |
|---|---|---|
| `.agents/` passes check.sh after installation | the wax_setup script that seeded this entry ran check.sh | pass |
