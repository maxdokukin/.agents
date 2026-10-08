# xaw_handoff — exact formats

Precise formats for everything the skill reads or writes. `SKILL.md` stays procedural and
points here. All paths are relative to `.agents/`.

## Entry filename

- Pattern: `yyyy-mm-dd-hh-mm-ss.md`, 24-hour clock, zero padded, UTC.
- Regex used for counting and sorting: `^[0-9]{4}(-[0-9]{2}){5}\.md$`
- Derivation: `date -u +%Y-%m-%d-%H-%M-%S`
- The stem is the filename without `.md`. The stem is also the entry's title suffix, its
  `Entry:` field, and its index key.
- Collision rule: if a file with the derived stem already exists, or the stem is not lexically
  greater than the current HEAD stem, wait one second and derive again. Never overwrite, never
  backdate (R-08).
- The template `handoffs/handoffs/yyyy-mm-dd-hh-mm-ss.md` does not match the regex and is
  never counted as an entry.

## HANDOFF.md

Line 1 is always the Updated line. Then the title, a two-line note, and three sections.

| Field | Value | Derived from |
|---|---|---|
| Updated line | `Updated <yyyy-mm-dd hh:mm:ss> UTC by xaw_handoff handoff. Read and written only by the xaw_handoff skill (R-04, R-05).` | time of the write |
| HEAD | `handoffs/handoffs/<stem>.md`, or `none` | greatest entry filename |
| HEAD timestamp | `<yyyy-mm-dd hh:mm:ss> UTC`, or `none` | HEAD stem |
| Entries | integer | count of files matching the regex |
| Last writer | `xaw_handoff handoff — <agent name>`, or `none` | the writing agent |
| Integrity | `consistent — HEAD is the newest entry file; entry count equals file count; every index row exists on disk. Validated at last write.` | the validate step, which must pass before writing |
| Status | `closed — resume with the pickup procedure of xaw_handoff.` or `empty — no entries yet; the first handoff creates HEAD.` | Entries > 0 or Entries = 0 |

The Integrity field only ever holds the `consistent` sentence. The skill never writes an
inconsistent state; it reports and stops instead (R-09).

### Index row

```
- **<stem>** — <Title from section 1> — <Session status from section 1> — next: <First action from section 9>
```

Newest first. One row per entry file, one entry file per row.

### Zero-entry state

A fresh copy of `.agents/` with no entries carries exactly this head block:

```
Updated <yyyy-mm-dd hh:mm:ss> UTC by xaw_handoff handoff. Read and written only by the xaw_handoff skill (R-04, R-05).

# HANDOFF

Head node of the handoff directory. It points at the newest entry and states the directory's
status. It holds no session content; that lives in the entry files.

## Head

- **HEAD:** none
- **HEAD timestamp:** none
- **Entries:** 0
- **Last writer:** none
- **Integrity:** consistent — HEAD is the newest entry file; entry count equals file count; every index row exists on disk. Validated at last write.
- **Status:** empty — no entries yet; the first handoff creates HEAD.

## Index (newest first)

(no entries)

## Template

- `handoffs/handoffs/yyyy-mm-dd-hh-mm-ss.md` — blank entry; copy it, never edit it (R-07).
```

## Entry file

Title line: `# Handoff <stem>`. Then ten sections with fixed numbers and headings.

| # | Heading | Content rule |
|---|---|---|
| 1 | `## 1. Session metadata` | Seven bold-key bullets: Entry, Title, Agent, Human, Previous HEAD, Session status (`complete` or `partial`), Project. |
| 2 | `## 2. Entry point (what was picked up)` | Verbatim copy of the previous HEAD's section 9, or the sentence `Fresh project, no previous HEAD.` Then one bullet `**Human request:**`. |
| 3 | `## 3. Work done` | Chronological bullets, one line each, past tense. |
| 4 | `## 4. Files read` | Relative paths, or `none`. |
| 5 | `## 5. Files written` | `<path> — <created \| edited \| moved \| deleted>` per line. |
| 6 | `## 6. Design decisions` | Blocks of `**Decision:**`, `**Why:**`, `**Alternatives rejected:**`. Rule deviations (R-03) and rule proposals (P-10) live here. |
| 7 | `## 7. Philosophical choices` | Principles meant to outlive the session. |
| 8 | `## 8. Open threads / next steps` | `- [ ]` checklist, highest priority first. |
| 9 | `## 9. Exit point` | Exactly four bullets, in this order, nothing else. See below. |
| 10 | `## 10. Verification state` | Table `\| Claim \| Verified by \| Result \|`, at least one row. `unverified` is a legal result (P-07). |

### Section 9 keys

These four strings are exact. The pickup procedure quotes them; the handoff procedure refuses
to write if any is missing or still contains a `<` placeholder.

```
- **Resume at:** <file, section, or task>
- **State:** <one sentence>
- **First action:** <one imperative sentence>
- **Blocked on:** <none | what must happen first>
```

### Completeness check

A filled entry contains no `<` placeholder outside code spans and comments, has all ten
headings in order, has the four section 9 keys, and has at least one row in section 10.
