### 2026-10-21 — Suggestions submission and owner inbox
- Halloween HTML adds native Suggestions details below Update Log, text form, 30-second client-side submit cooldown, and owner-only inbox in signed-in Cloud Save panel with Refresh and Mark Reviewed. Submissions stored in new `public.game_suggestions` (3–1000 chars; new/reviewed status), with anonymous/authenticated insert-only, authenticated owner-email-gated select/update RLS. UI escapes submissions with textContent. No save format changes. HTML commit `9adeb8dd96abc38053b41f7d3349957514b50b7e`; reverse HTML commit for UI rollback; database table can remain unused or be separately reviewed for removal, preserving submitted ideas. Browser end-to-end testing pending. Client cooldown is not server-side anti-spam.

### 2026-10-21 — Public update-log spoiler rule
- Halloween login Update Log now says only that Insomniac and $$$ were added. Never reveal title unlock methods in public update notes unless explicitly requested; retain exact mechanics privately in development documentation. Revert the dedicated HTML commit to roll back this wording change.

### 2026-10-21 — Editable Update Log on login screen
- Added native `<details id="game-update-log">` beside the existing entry card, responsive CSS, and a plainly marked `EDITABLE UPDATE LOG` HTML section containing latest update text. No JavaScript/auth/save changes. On narrow screens the log moves below login card. HTML commit `5634b6f38e06cdf0ff085aaf22d1f51f874a5aea` on Halloween; revert this single commit for rollback. Source verification done; real Chrome layout test pending.

### 2026-10-20 — Reversible login entry screen
- HTML-only Halloween change: `#game-entry-gate` overlay, scoped styling, `game-entry-locked` body state, move existing `#cloud-logged-out` controls into the entry card on initialization, toggle entry visibility from `updateCloudUI()`. No duplicate login handlers, account/save/schema changes, or layout moves to game panels.
- Rollback: revert HTML commit `ba05004a4e4e92edb4bffe40f4c86276db78dae9` on Halloween; no database rollback needed. Source re-fetch verification performed; browser login, signup, session restoration and logout still need testing.

### 2026-10-20 — Insomniac title
- Added `insomniac` discovery, text gradient, owned/chat badges, owner test and selected-player management, and local-midnight interval detection to Halloween HTML. Midnight crossing must occur while the page remains open and signed in; a delayed timer over two minutes is not counted. Unlimited claims: no global claim row.
- Added `claim_insomniac_title` RPC, ownership and active-title check-constraint entries, and owner RPC whitelists. Verified committed HTML and database definitions, but not live browser midnight behavior. HTML commit `58164235af414f09e61c7eabbf80cc5feb596c28`. Roll back HTML commit on Halloween and separately reverse the additive database changes if needed. Main and game-development untouched.

### 2026-10-20 — $$$ title
- Halloween HTML adds discovery card, solid green styling, chat/collection/popup display, admin/test selectors and a periodic threshold check. Supabase migration `add_halloween_money_title` adds authenticated `claim_money_title()` verifying 100 million current clicks in cloud save, and extends owner test/manage RPC allowlists.
- No main or game-development changes. Browser testing pending. Rollback HTML commit `98b094ee5c45224a01722f8c78eac2d9ac6a4388`; review migration dependencies before database rollback.

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

## 2026-10-12 — Halloween title collection / test claim implementation

- **Branch:** `Halloween` only. `game-development` and `main` were not changed.
- **HTML commit:** `10fab29dc8b291a808ec39b7ef80f149f6032c62`; owner-only visibility safeguard: `1b830d55eb3ff9dcef09b8eb16f18585784608d8`; sidebar width alignment: `9dcc3690c7977fe8d38b21c140d52303fa18de63`; owner-session visibility safeguard: `c9e06d26571bd7848d9b1c9377df5bc9a5f54e88`.
- **UI:** Added a title collection panel directly below Chat in the same sidebar. Players can view titles they own and activate/deactivate them. Active title text is shown in orange before the username in global chat. The owner sees test controls and a popup preview. The Admin Panel can grant/remove The Spookyest for the currently selected player while Owner Player List Mode is active.
- **Claim design:** `public.game_title_claims` has a unique primary key by title, so concurrent real claims serialize to one winner. `claim_spookyest_title(false)` checks the caller's cloud save for at least 10 rebirths, atomically claims the title, then records earned ownership. `claim_spookyest_title(true)` is owner-email-only and records a test grant without touching the one-time claim row. Admin grants use the same test-grant source; removal clears active preference if it points to the removed title. Test grants can be activated and shown in chat like any other owned title, and a qualified test-grant recipient can later convert it to earned ownership if the real claim remains free.
- **Database changes:** Applied Supabase migrations `add_halloween_title_collection_and_test_claims`, `allow_chat_to_display_active_titles`, `restrict_title_rpc_to_authenticated_users`, and `restrict_title_table_grants`. Tables: `game_player_titles`, `game_title_preferences`, `game_title_claims`. RPCs: `get_spookyest_title_status`, `claim_spookyest_title`, `set_active_game_title`, `owner_manage_game_title`. All title tables have RLS enabled. Title ownership reads are limited to self and the existing owner account; active-title preference reads are allowed for signed-in players so chat can render public active titles. Mutations run through authenticated RPCs; owner grants/removals and test mode are checked server-side. Explicit grants verification confirms the title RPCs are executable by `authenticated` and not executable by `anon`; table privileges confirm that unauthenticated users have no access, authenticated users can only read ownership/preferences, and neither can directly mutate title records. The claim table is accessible only through guarded RPCs.
- **Verification completed:** Migration tool reported success. HTML structural checks confirmed one `<html>` root, balanced `<style>` and `<script>` tags, one title panel, one title refresh function, and one five-second title refresh interval. Both inline JavaScript blocks passed syntax compilation. Owner title management is hidden by default, shown only after owner identity checks, and hidden again when the owner session ends. No new duplicate IDs were introduced. A duplicate `owner-player-list-admin-mode` ID existed in the original HTML and was intentionally not changed.
- **Verification still required:** Browser testing is outstanding. The assistant did not execute the game in a browser or verify downloaded standalone Chrome-tab layout. Test popup, test claim non-consumption, activation/deactivation, global chat badge, owner grant/removal, normal 10-rebirth claim, and two-account simultaneous claim should be tested before release.
- **Rollback:** Revert the HTML commit on `Halloween`. Database objects may be dropped only after checking that no other branch uses them. Never change `game-development` or `main` without explicit authorization.

---

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

### 2026-10-12 — Halloween Admin Abuse event (initial testing build)

- **Request/problem:** Add an occasional, very powerful server-wide event to the Halloween version, controlled only by the owner through the existing Admin Panel.
- **Root cause/design:** A shared event cannot be implemented reliably with local browser state alone. The event settings therefore live in the connected Supabase database, while only the Halloween HTML reads and applies them.
- **Change made:** Added a compact owner-only Admin Abuse section to the existing admin panel, with an activation toggle, a shared click/auto-clicker multiplier (default 10), and an upgrade discount percentage (default 50). The event defaults to inactive. While active, manual clicks and regular auto-clicker output share the multiplier; Gem Station CPS is not multiplied. Upgrade cost helpers for click upgrades, auto-clickers, temporary upgrades, Gem Station upgrades, discount upgrades, and More Gems/Rebirth upgrades apply the event discount, with a minimum cost of 1. Added a player-facing active banner and one popup when a client first detects the event becoming active. Clients poll the single settings row every five seconds, so changes reach other open clients without requiring Realtime publication changes.
- **Files/functions touched:** Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html; getAdminAbuseClickMultiplier(), getAdminAbuseUpgradePriceMultiplier(), loadAdminAbuseSettings(), saveAdminAbuseSettings(), applyAdminAbuseSettings(), click/CPS calculations, upgrade cost helpers, and the owner-only admin UI.
- **Database change:** Applied Supabase migration add_global_admin_abuse_event to project itriqucjgayokvddrbxm. It creates public.game_admin_abuse with a single row (id 1), seeded inactive at ×10 / 50% off. RLS is enabled. anon and authenticated can read the row; only authenticated sessions whose signed JWT email equals the game owner's configured email can update it. No public insert/delete permission was granted. Verified the row and policies with read-only SQL queries.
- **Security boundary:** The client additionally requires the owner account and unlocked Admin Panel before saving, but the database RLS policy is the real authorization boundary. A non-owner cannot update the event row merely by manipulating client-side JavaScript.
- **Preserved behavior:** No change to save data shape, save keys, rebirth logic, bank conversion, Gem Station output, chat, layout placement, or the regular game-development / main HTML. The shared Supabase table exists at the project level, but only the Halloween branch is wired to use it.
- **Tests run and results:** Verified the table's default row (active=false, click_multiplier=10, upgrade_discount_percent=50) and confirmed RLS policies for public SELECT and owner-only UPDATE. Re-fetched the HTML after commit; file length is 178,490 characters, HTML/style/script open-close counts balance, and the new controls and helper functions appear once where expected.
- **Not tested / user testing needed:** Browser/standalone execution, successful update from the owner's real session, non-owner rejection through the client, cross-client 5-second polling, popup/banner behavior, discount effect across purchase types, and restoring normal behavior after deactivation. The assistant's environment could not download the raw GitHub file to run a local JavaScript parser, so no JS syntax execution or browser test is claimed.
- **Code commit SHA:** 185b7b77c75cba4aabcaef6b3ea6cef22b04b550.
- **Rollback:** Revert the HTML commit on Halloween. To turn off the live event immediately, update row 1 to active=false using the owner's Supabase session/dashboard. To fully roll back the schema after code rollback, drop public.game_admin_abuse only when no game branch uses it. Do not edit game-development or main.

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

### 2026-10-12 — Make title-management controls reliably visible
- **Request/problem:** Ensure the owner can see the title grant/remove controls in the Halloween Admin Panel.
- **Root cause:** The title-management section was initially hidden and its visibility depended on title refresh timing. The Admin Panel's unlock/lock state did not explicitly refresh that section.
- **Change made:** The title section now requires both owner identity and an unlocked Admin Panel to display. Updating owner Admin controls now refreshes title-management visibility, so unlocking makes it appear and locking hides it again.
- **Files/functions touched:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`; `refreshOwnerTitleTools()`, `updateOwnerAdminControls()`.
- **Preserved behavior / compatibility:** No title-claim rules, title grant/removal RPCs, chat rendering, save schema, general layout, `game-development`, or `main` were changed.
- **Tests run and results:** Confirmed the updated visibility condition and refresh call are present in the source. No live browser test was performed.
- **Not tested / user testing needed:** Sign in as the owner on the Halloween branch, unlock Admin Panel, confirm “Title Management (Owner Only)” appears, then lock Admin and confirm it hides.
- **Commit SHA:** `c1d88def3547abb452f9dfbdb9a87f83c89bed22` (HTML); documentation update follows.
- **Rollback instructions:** Revert the HTML visibility-fix commit on `Halloween`; no changes were made to other branches.
### 2026-10-12 — Release the limited title when owner removes it
- **Request/problem:** Removing The Spookyest should make the limited public claim available again.
- **Root cause:** The owner removal RPC deleted the player's title ownership and active preference, but left the separate one-time claim row intact.
- **Change made:** Updated `public.owner_manage_game_title(uuid,text)` to delete the public claim record when and only when its `claimed_by` user matches the selected player being stripped of the title. Removing an unrelated test grant does not affect the true claimant.
- **Files/functions touched:** Supabase function `public.owner_manage_game_title(uuid,text)`; Halloween branch documentation.
- **Preserved behavior / compatibility:** Grants remain test grants; title eligibility and atomic claim flow remain unchanged. The currently recorded claim was not deleted during verification.
- **Tests run and results:** Supabase migration returned success. Queried current claim state after migration and confirmed the existing claim record remained in place. Did not simulate a destructive owner removal or second account claim.
- **Not tested / user testing needed:** In Halloween branch, remove The Spookyest from its current claimant; verify status shows available, then test claim from a qualified account.
- **Rollback instructions:** Reapply the previous function definition from Git history/migration history. This is a server-side behavior change; reverting the HTML alone will not roll it back.

