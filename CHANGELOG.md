# Ultimate Idle Clicker — Changelog

This file records user-visible behavior changes and meaningful project changes. New entries go at the top. Do not invent history or claim tests that were not performed. Detailed implementation and rollback notes belong in [DEVELOPMENT_LOG.md](DEVELOPMENT_LOG.md). The editing contract is in [DEVELOPMENT_RULES.md](DEVELOPMENT_RULES.md).

## Unreleased

### 2026-11-03 — Add random shop admin testing controls
- **Problem/request:** Let an admin force the local shop to appear and inspect each automatic five-minute spawn attempt, including failures and successes.
- **Change:** Added a Random Shop Controls section inside the unlocked Admin Panel. The Force Spawn Shop button is guarded by the existing `adminUnlocked` state and does not replace a shop that is already active. Automatic five-minute rolls now record SUCCESS or FAILED, the local attempt time, and whether the result came from the one-hour guarantee, a successful random roll, or a missed roll. Manual spawns are recorded as FORCED. The panel shows the latest attempt and a reverse-chronological history capped at 30 entries. This diagnostic history is session-local and resets when the page reloads; it does not use Supabase or game saves.
- **Files:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`
- **Verification:** Re-fetched the committed HTML from `game-development`; checked the admin section/button, admin-unlock guard, success/failure logging, timestamps, 30-entry cap, local-only behavior, and balanced script/style tags.
- **Not tested:** No browser/admin-login interaction test or real five-minute wait-through test was performed.
- **Commit:** `b7d578d8723f9fd2d9c872138deda87176c24dc8`
- **Rollback:** Revert the HTML commit above on `game-development`; the previous random shop framework remains in the prior commit.


### 2026-11-03 — Add the local random traveling shop framework
- **Problem/request:** Add an individually timed shop that checks for an appearance every five minutes, is guaranteed to appear within one hour, stays available for ten minutes, and does not use Supabase for its timer or shared state.
- **Change:** Added a fixed top-left Traveling Shop button and a toggleable placeholder shop panel. Each page session has its own timer: a 5% spawn chance at each five-minute check, forced appearance at the one-hour check, and a ten-minute active window. When the window expires, a fresh local cycle begins. Reloading or reopening the game starts a fresh timer and hides any previous shop. Closing only the shop panel leaves the button and its current visit intact. Inventory is held in a session-only variable and is initialized once per appearance; actual randomized offers are intentionally pending the user's shop-content design.
- **Files:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`
- **Verification:** Re-fetched the committed HTML from `game-development`; checked the button/panel IDs, local-only timer, 5% check, one-hour guarantee, ten-minute expiry, new-cycle reset, and balanced script/style tags. No Supabase calls, save fields, or local-storage keys were added.
- **Not tested:** No real browser wait-through test was performed. The one-hour guarantee and ten-minute expiration still need an in-browser test; actual shop offers/purchases are not implemented yet.
- **Commit:** `4163ca6a47b2539eb60240162de9f355d7a0eb46`
- **Rollback:** Revert the HTML commit above on `game-development`; no other branch or database was changed.


### 2026-10-12 — Keep Cloud Save directly under the main game interface
- **Problem/request:** Keep Cloud Save easy to reach as new panels and features are added, rather than letting it drift farther down the page.
- **Change:** Moved the existing Cloud Save panel into the main game panel, immediately below the main interface and rebirth control. The Cloud Save contents and behavior were not changed.
- **Files:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`
- **Verification:** Source checks confirmed one Cloud Save panel, placed after the rebirth control and before the Gem Station section; HTML still ends correctly. No browser/standalone-tab test was performed.
- **Commit:** `5fcc9d356233ccfe56ad67db7cd93ca50db2df5e`
- **Rollback:** Revert this commit on `game-development` to restore the previous Cloud Save position.


### 2026-10-12 — Improve cloud-save reliability
- **Problem/request:** Make progress sync more reliable between devices and prevent stale saves from replacing newer cloud progress.
- **Change:** Queue save attempts that overlap a load/save; defer load-related saves until loading finishes; load cloud data when the signed-in account changes (not on token refresh); replace check-then-upsert with a conditional update or insert so a concurrent cloud change is not silently overwritten.
- **Files:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`
- **Verification:** Source-level review of the changed save/load/auth flows; GitHub file re-fetched after the code commit.
- **Not tested:** Real two-device sync against the live Supabase project; browser execution and race-condition testing still required.
- **Commits:** `66873d21996ba0d0a260a7e6edec37befadeacfc` and `9e1a5aea7344c3a8375d14690507b35d7f51d6fa` (game code).
- **Rollback:** Revert the game-code commit above on `game-development`; no changes to `main` or database schema.

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
