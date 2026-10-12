# Ultimate Idle Clicker — Changelog

This file records user-visible behavior changes and meaningful project changes. New entries go at the top. Do not invent history or claim tests that were not performed. Detailed implementation and rollback notes belong in [DEVELOPMENT_LOG.md](DEVELOPMENT_LOG.md). The editing contract is in [DEVELOPMENT_RULES.md](DEVELOPMENT_RULES.md).

## Unreleased

### Current priority
- Fix reliable cross-device cloud saving first. The same account should load its latest progress on another device, without an older save overwriting newer progress.
- Offline progress is a separate follow-up priority; do not bundle unrelated changes into the cloud-save fix.
- No code change for this current priority has been recorded in this entry yet; this is a task note, not a claim that the fix is implemented.

## Historical summary (reconstructed from available project records; not a complete release history)

The following items summarize known prior work. This list may not include every earlier change, and it is not a substitute for the original commit history.

- Added Supabase-backed account/cloud-save functionality and autosave-related behavior.
- Added Bank functionality, including banked clicks, conversion, interest, persistence, and offline-related behavior.
- Added multi-purchase upgrade controls and buy-max behavior.
- Adjusted rebirth progression so rebirth requirements involve both upgrades and clicks.
- Added username support intended to avoid exposing account email addresses in chat.
- Added game chat and related signed-in player features.
- Added permanent Gem Station upgrades and temporary upgrade systems.
- Worked on standalone desktop layout so the main game stays centered, with Gem Station and administrative controls placed separately.
- Fixed auto-clicker generated-click behavior with a fractional accumulator and safe click addition.
- Fixed a clicker-station CPS function naming/capitalization mismatch.
- Added safe normalization for saved game values.
- Added a guard to prevent the game loop from continuing during Hard Reset.

### Known commit references from available project records

- `83623a4c9940bae45aa25f151316c9190f0cf424` — clicker-station CPS function name fix.
- `bc5356ad619bc9b68f63340f33ac88590ad18d2c` — safe normalization work.
- `b99d81874d218e5f52e20fbbdf6254304252c615` — fractional auto-click accumulator and safe generated-click addition.
- `ef7b809feb34eee0d6795726858af1a9f5a27319` — Hard Reset/game-loop guard fix.

These commit descriptions are brief summaries from available notes; consult GitHub commits for authoritative diffs.

## Entry format for future changes

For every meaningful change, add an entry like this at the top under `Unreleased` or under a dated/versioned heading:

```md
### YYYY-MM-DD — Short change title
- **Problem/request:** What the user asked to fix or add.
- **Change:** What was actually changed.
- **Files:** Exact paths changed.
- **Verification:** Tests actually run and their results.
- **Not tested:** Anything that still needs a real browser/device/account test.
- **Commit:** Full or abbreviated GitHub commit SHA.
- **Rollback:** Commit or file backup that safely restores the prior behavior.
```

Do not mark a problem as fixed solely because a commit was created. Record any real-world verification still needed.
