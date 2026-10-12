# Ultimate Idle Clicker — Development and Rollback Log

This is the durable engineering record for future work across chats. It should contain enough context for another developer or assistant to understand what changed, what was checked, and how to reverse it safely.

Read [DEVELOPMENT_RULES.md](DEVELOPMENT_RULES.md) before making edits. Record user-facing summaries in [CHANGELOG.md](CHANGELOG.md).

## Current project baseline

- Repository: https://github.com/27nelsonc-oss/Ultimate-Idle-Clicker
- Development branch: `game-development`
- Protected branch: `main` — do not edit or merge without explicit authorization.
- Current game HTML path at the time this log was initialized:
  `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`
- The HTML file on `game-development` is the development source of truth. Always fetch the latest copy and blob SHA before editing.
- This log was created to preserve project rules and work history across conversations. It does not modify game code.

## Current active task

### Cross-device cloud saving — not yet fixed by this documentation commit

**Desired result:** After a player saves progress on one device and signs into the same account on another device, the second device loads the latest cloud progress. An older local state or overlapping save must not overwrite newer progress.

**Scope:** Inspect and fix the cloud save/load/login/autosave path only. Do not combine this with an offline-progress overhaul, UI redesign, balancing changes, or unrelated features.

**Previously identified code paths to inspect (re-fetch before relying on line numbers):**
- `saveGame()` and `loadGame()`
- `cloudSaveGame()` and `cloudLoadGame()`
- `initializeCloudSave()`
- Login/signup handlers and Supabase auth-state listener
- Local save interval and cloud autosave interval
- Reset-version handling and any caller that can trigger a save/load

**Potential hazards noted during prior inspection (must verify against current source before patching):**
- Local and cloud autosave intervals may overlap.
- Multiple cloud writes may race, potentially allowing stale data to overwrite newer data.
- `cloudSaveGame()` reportedly refuses to run while `cloudLoadInProgress` is true, while `cloudLoadGame()` may attempt a save before that flag is cleared.
- Local load and cloud load have different offline-progress behavior.
These are investigation leads, not confirmed final root causes.

**Acceptance checks:**
1. Cloud data is loaded for the authenticated account on startup/login in the intended order.
2. Loading an account does not immediately overwrite the cloud with stale local state.
3. Older or overlapping writes cannot silently replace a newer state.
4. Existing reset-version protections still work.
5. Existing local save and download workflow still work.
6. The same account can be checked on two devices; if this cannot be tested by the assistant, explicitly ask the user to perform that test.
7. Offline progress remains out of scope unless directly necessary for this fix.

## Known protected behavior

Preserve the existing game features, including clicking/Space/Silent Clicking, auto-clickers, upgrades and multi-buy, rebirth and gem upgrades, Gem Station, Bank, offline progression, username/chat/DM/presence, admin/tester tools, Hard Reset, and existing save compatibility. See the rules document for full requirements and layout constraints.

## Historical fixes known from project notes

These entries are brief historical summaries. Verify actual diffs in GitHub before using them as a basis for further changes.

- Commit `83623a4c9940bae45aa25f151316c9190f0cf424`: corrected clicker-station CPS function naming.
- Commit `bc5356ad619bc9b68f63340f33ac88590ad18d2c`: safe normalization for game/save values.
- Commit `b99d81874d218e5f52e20fbbdf6254304252c615`: fractional accumulator and safe click addition for auto-clickers.
- Commit `ef7b809feb34eee0d6795726858af1a9f5a27319`: Hard Reset/game-loop guard.

## Change record

### 2026-10-12 — Add persistent development documentation
- **Problem/request:** Preserve the user's editing rules, priorities, and change-history expectations in GitHub so future chats do not need to carry the entire rules list.
- **Change:** Added `DEVELOPMENT_RULES.md`, `CHANGELOG.md`, `DEVELOPMENT_LOG.md`, and a root `README.md` index.
- **Files:** Documentation only; no game HTML or game logic changed.
- **Verification:** Verify the resulting files and commits on `game-development` after the writes complete.
- **Not tested:** No game code changed, so no gameplay or cross-device sync test was performed.
- **Rollback:** Revert the documentation commits if necessary; no game code was changed by these docs.

## Required template for each future implementation entry

### YYYY-MM-DD — Short title
- **Request/problem:**
- **Root cause:** Separate confirmed findings from hypotheses.
- **Change made:** Describe behavior and code path.
- **Files/functions touched:**
- **Preserved behavior / compatibility:**
- **Tests run and results:**
- **Not tested / user testing needed:**
- **Commit SHA:**
- **Rollback instructions:** Exact prior commit/file and safe steps.
