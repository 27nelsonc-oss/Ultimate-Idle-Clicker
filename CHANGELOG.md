# Ultimate Idle Clicker — Changelog

## Unreleased

### 2026-10-12 — Halloween Admin Abuse event (initial testing build)
- **Request:** Add a powerful, temporary server-wide Admin Abuse event to the Halloween branch only, with owner-controlled settings.
- **Change:** Added an Admin Abuse section visible only to the owner account after the Admin Panel is unlocked. Defaults are inactive, ×10 for both manual clicks and regular auto-clickers, and 50% off eligible upgrade costs. The multiplier and discount can be edited independently; the same multiplier controls both clicking and auto-clicking. Eligible click-priced and gem-priced upgrade costs use the event discount, with a minimum price of 1. Added an active banner and a popup when a client detects the event starting. Clients poll shared settings every 5 seconds.
- **Server security:** Added public.game_admin_abuse to the connected Supabase project. RLS allows public read access to the single event row but restricts updates to the owner's authenticated email at the database policy level. The row starts inactive. The Halloween HTML is the only branch wired to this setting; the regular game remains unchanged.
- **Files:** Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html
- **Verification:** Confirmed the database row exists with active=false, multiplier 10, and discount 50; verified RLS policies for public reads and owner-only updates. Re-fetched the committed HTML and confirmed balanced HTML/style/script tags and the new event controls/helpers are present.
- **Not tested:** No browser execution or downloaded standalone Chrome-tab test was performed. Owner login/update behavior, popup timing, cross-client polling, discount coverage, and turning the event off need real browser testing.
- **Code commit:** 185b7b77c75cba4aabcaef6b3ea6cef22b04b550.
- **Database rollback:** To disable the feature without deleting schema, set active=false on row id=1. To fully remove the feature after reverting the HTML, drop public.game_admin_abuse only if no branch uses it.
- **Code rollback:** Revert the HTML commit on Halloween only. Do not change game-development or main.

This file records user-visible behavior changes and meaningful project changes. New entries go at the top. Do not invent history or claim tests that were not performed. Detailed implementation and rollback notes belong in [DEVELOPMENT_LOG.md](DEVELOPMENT_LOG.md). The editing contract is in [DEVELOPMENT_RULES.md](DEVELOPMENT_RULES.md).

### 2026-10-12 — Halloween theme colors
- **Request:** Apply a Halloween orange-and-black color theme to the separate `Halloween` branch only, preserving the regular game layout and gameplay.
- **Change:** Updated the existing theme palette, main-button glow/accent, upgrade and rebirth button colors, panel/input borders, and related decorative colors. Kept the current layout, wording, game mechanics, save format, and semantic success/error colors unchanged.
- **Files:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`
- **Verification:** Re-fetched the committed HTML; confirmed the Halloween palette is present, the old turquoise accent is absent, and the HTML/style tag counts remain balanced. No browser rendering test performed.
- **Not tested:** Downloaded standalone Chrome-tab appearance and mobile appearance need user verification.
- **Commit:** `1534f76c158b7b6a22830709b9618cbeba2a254d` (HTML theme change).
- **Rollback:** Revert this commit on the `Halloween` branch only. The `game-development` and `main` branches were not edited by this change.

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
