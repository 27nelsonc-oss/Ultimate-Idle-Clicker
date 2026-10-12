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

### 2026-10-12 — Halloween orange-and-black palette
- **Request/problem:** Give the Halloween version a seasonal color theme before adding Halloween-specific features, without changing the regular game.
- **Root cause:** No bug; this is a visual-only seasonal customization.
- **Change made:** Updated the HTML's existing CSS colors: page and panel backgrounds now use warmer near-black tones; the main accent and glow use Halloween orange; upgrade controls use warm charcoal/brown; rebirth controls use orange; Gem Station upgrade controls use dark purple; input and decorative borders use warm brown. Kept layout, text, handlers, gameplay, save format, and success/error status semantics unchanged.
- **Files/functions touched:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`; CSS declarations only.
- **Preserved behavior / compatibility:** No JavaScript logic, Supabase behavior, save keys/schema, account data, or layout rules intentionally changed.
- **Tests run and results:** Re-fetched the committed HTML and confirmed the orange/black palette is present, the previous turquoise accent is absent, the normal `game-development` branch retains its original palette, and HTML/style opening/closing tag counts are balanced. No browser execution was performed.
- **Not tested / user testing needed:** No actual browser render, downloaded separate-tab test, or mobile visual test performed. User should check the `Halloween` branch's HTML in a separate Chrome tab.
- **Commit SHA:** HTML change `1534f76c158b7b6a22830709b9618cbeba2a254d`; this log/changelog documentation follows separately.
- **Rollback instructions:** Revert the HTML theme commit on `Halloween` to restore the previous palette. Do not revert or alter `game-development` or `main` for this task.

### 2026-10-12 — Cloud-save ordering and stale-write protection
- **Request/problem:** Improve cross-device cloud saving without changing gameplay, UI, or the Supabase schema.
- **Root cause confirmed in source:** `cloudSaveGame()` used a separate timestamp check followed by an unconditional upsert, leaving a race window where another device could write newer progress. Save attempts were dropped when either a load or save was already active. `cloudLoadGame()` called cloud save before its own loading lock was released, so that save attempt was refused. The auth-state listener also initialized account features without first loading that account's cloud save.
- **Change made:** Replaced the upsert with a conditional update matching the exact `updated_at` and `reset_version` just read, and uses insert-only when no row exists. A zero-row conditional update is treated as a conflict, not success. Save requests that overlap load/save are queued and retried after the active operation releases its lock. Offline-progress and reset-related save requests are deferred until loading completes. Auth-state changes load the signed-in account's cloud save before the remaining account setup continues, but token refreshes do not reload cloud data and overwrite progress being played locally.
- **Files/functions touched:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`; `cloudSaveGame()`, `cloudLoadGame()`, auth-state listener.
- **Preserved behavior / compatibility:** Kept the existing `game_saves` table and its `user_id`, `save_data`, `reset_version`, and `updated_at` fields; retained the existing local-save key, reset-version protections, save data shape, UI, and gameplay. No database schema changes.
- **Tests run and results:** Re-fetched the committed HTML from `game-development` and confirmed the new queued-save and conditional-write code is present. Source flow reviewed for the changed branches.
- **Not tested / user testing needed:** The live Supabase account was not available for a real two-device test; browser/runtime syntax and concurrent-session behavior still need verification. Do not consider cross-device sync fully proven until that test passes.
- **Commit SHA:** Game code `66873d21996ba0d0a260a7e6edec37befadeacfc` plus auth-refresh safeguard `9e1a5aea7344c3a8375d14690507b35d7f51d6fa`; this log and changelog are separate follow-up documentation commits.
- **Rollback instructions:** Revert the cloud-save code commit on `game-development` to restore the prior HTML. The prior game version remains in Git history; `main` was not modified.

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
