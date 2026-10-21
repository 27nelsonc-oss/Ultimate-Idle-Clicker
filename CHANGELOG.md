# Ultimate Idle Clicker — Changelog

## Unreleased

### 2026-10-21 — Move announcement editing to the login panel
- Moved the owner-only announcement editor from the in-game Admin panel into the left-side login Announcements panel. Publishing and clearing are now available directly in that section.
- Removed the announcement banner from the gameplay screen. Announcements now appear on the login menu only; the existing Supabase announcement record, owner-only write checks, and realtime updates are reused.
- **HTML commit:** `5922407a3323ba21b2c0983d6d4496032d1851ef`.
- **Verification:** Source-level checks are recorded after the edit; live browser and owner/non-owner account testing have not been performed.
- **Rollback:** Revert HTML commit `5922407a3323ba21b2c0983d6d4496032d1851ef` on `Halloween`; no other branch was changed.

### 2026-10-21 — Add always-visible login announcements
- Added a persistent Announcements panel on the left side of the Halloween login/menu screen. It is visible by default, including when no announcement is currently published.
- The panel reuses the existing owner-managed global announcement stored in Supabase, so publishing or clearing the existing announcement updates the login panel too. No new database table or policy was needed.
- The panel stacks below the centered login card on narrower screens to avoid pushing the card off-center or clipping the side panels.
- **HTML commit:** `01626c8046efa10f7be2448b14b4aeff3fbdd132`.
- **Verification:** Source anchors were checked before editing. Live browser/responsive-layout testing has not been performed.
- **Rollback:** Revert HTML commit `01626c8046efa10f7be2448b14b4aeff3fbdd132` on `Halloween`; no other branch was changed.

### 2026-10-21 — Add Pulls player voting
- Added a Pulls menu beneath Suggestions on the Halloween login/menu screen. The owner can release one active poll at a time with a question and 2–8 options, then close voting to preserve final results. Signed-in players can vote once per poll and view option totals/percentages; a Refresh Results button reloads counts.
- Added Supabase tables for polls, options, and votes with RLS policies. Vote rows are private to the voter; aggregate counts are exposed through `get_game_poll_results()`. Poll creation and closure are owner-only. No gameplay/save logic changed.
- **HTML commit:** `b2f5a1df9d6faf366fd7d66d04c549f8846f46bd`; refresh button follow-up: `09a5658348276697a733132c0497880609606c87`. Supabase migrations: `add_player_polls_and_votes` and `qualify_poll_vote_policy`.
- **Verification:** Confirmed all three tables have RLS enabled and policies (4 poll, 3 option, 2 vote); aggregate RPC is executable by authenticated users but not anon. Both inline JavaScript blocks compile and no duplicate HTML IDs were found. Browser-based end-to-end voting has not been tested.
- **Rollback:** Revert the two HTML commits on `Halloween` and, if the feature is removed permanently, remove the poll tables/function through a separate reviewed Supabase migration. Do not touch `game-development` or `main`.

### 2026-10-21 — Update in-game player-facing Update Log
- Updated the login-screen Update Log to reflect the implemented login screen, Update Log and Suggestions panels, Log Out button, centered desktop menu card, Insomniac title, and $$$ title. Title names are listed without revealing unlock methods.
- **HTML commit:** `ca02b645600425c8414f0888884dfd9504e353c0`. Halloween branch only; no gameplay, authentication, save, or database logic changed.

### 2026-10-21 — Keep login/menu card centered
- Kept the main login/menu card centered in the viewport while placing Update Log and Suggestions to its right on desktop. The sidebar no longer contributes to the card’s centering calculation. On narrow screens, the sidebar returns to normal flow beneath the card. Log Out remains beneath Resume Game. No authentication, game, save, or database logic changed.
- **HTML commit:** `37b1ec0250261abbdf59a126e4ddfc387dfb699a`. Static CSS/markup checks passed; browser rendering test still pending. Roll back by reverting this HTML commit on `Halloween` only.

### 2026-10-21 — Align right sidebar with login card
- Adjusted the desktop layout wrapper so the Update Log and Suggestions sidebar begins level with the top of the login/menu card, restoring the original side-by-side placement rather than sitting too high. The two panels remain in normal flow and do not overlap when Update Log expands; narrow screens still stack them below. Log Out remains beneath Resume Game. Halloween only; no auth/save/database changes. Browser testing pending.

### 2026-10-21 — Restore right-side Update Log and Suggestions
- Moved Update Log and Suggestions into a dedicated sidebar to the right of the login/menu card on desktop, preserving their vertical flow so opening Update Log pushes Suggestions down rather than overlapping it. On narrow screens the sidebar stacks below the card. Kept the Log Out button beneath Resume Game. Halloween only; no authentication, save, or database changes. HTML commit pending. Browser testing pending.

### 2026-10-21 — Menu logout and stacked login panels
- Added a Log Out button beneath Resume Game in the signed-in menu, reusing the existing logout handler. Update Log and Suggestions now stack vertically inside the login/menu card, so opening either expands the card and pushes the next section down instead of overlapping it. Halloween only; no auth/save/database changes. HTML commit `67433d1ad098c9feba199ee9798553a5978e0e1a`. Browser testing pending.

### 2026-10-21 — Return to menu without logout
- Signed-in players can press Esc to reopen the existing menu and Resume Game to return without logging out. Added a small fixed ☰ Menu button for mobile/touch users. Existing Update Log and Suggestions remain accessible. No save/auth/database changes. HTML commit `5be09ab9e31f1aa0e04d330b8a7cb504031e6d5e`; browser testing pending.

### 2026-10-21 — Player suggestions
- Added expandable Suggestions under Update Log on Halloween login screen. Visitors can submit 3–1000 character ideas; owner can privately review the newest 100 in the Cloud Save panel and mark them reviewed. No title discovery spoilers added. Database table has row-level security; other players cannot read submissions. HTML commit `9adeb8dd96abc38053b41f7d3349957514b50b7e`. Browser submission/review testing pending.

### 2026-10-21 — Keep title discoveries secret in public Update Log
- Changed public login-screen Update Log title entries to names only, without unlock conditions. Future player-facing update notes should not reveal title discovery requirements.

### 2026-10-21 — Editable login-screen Update Log
- Added a right-side expandable Update Log to the Halloween login screen, with a responsive below-card layout on narrow screens. Populated it with the recent login screen and title additions. Text is editable directly in a clearly marked HTML section; no database changes.
- HTML commit `5634b6f38e06cdf0ff085aaf22d1f51f874a5aea`. Browser layout testing pending; revert this commit to remove it.

### 2026-10-20 — Reversible login entry screen
- Added a full-screen Ultimate Idle Clicker welcome/login view on Halloween only. Reuses the existing cloud email/password, Create Account and Log In controls; game becomes visible after sign-in and the entry screen returns after logout. Existing sessions are recognized. No authentication schema or save format changes.
- HTML commit `ba05004a4e4e92edb4bffe40f4c86276db78dae9`; browser login/logout testing pending. Revert this single HTML commit to remove the screen.

### 2026-10-20 — Insomniac Halloween title
- Added unlimited Insomniac title for signed-in players with the game open as local midnight arrives. Hint exactly: Sleep is a recommendation. Dark blue → lighter blue → light yellow → dark yellow text gradient. Added owner grant/remove and popup preview, and database ownership/equip support.
- HTML commit: `58164235af414f09e61c7eabbf80cc5feb596c28`. Source and database definitions verified; real midnight browser test pending. Halloween branch only.

### 2026-10-20 — Add $$$ title
- Added a solid dark-green $$$ title for reaching 100 million current clicks, with only the hint “My Economic Rain has Begun”. Added owner testing/management and cloud-backed claim. Halloween branch only.
- HTML commit: `98b094ee5c45224a01722f8c78eac2d9ac6a4388`. Browser testing pending.


### 2026-10-12 — Release The Spookyest when owner removes it
- **Request:** Ensure removing the title from its holder makes the limited public title available again.
- **Change:** Updated the server-side `owner_manage_game_title` RPC so removing The Spookyest also deletes the one-time claim record only when that selected player is the recorded claimant. Removing a test grant from someone else does not release or affect the actual claimant's title.
- **Verification:** Applied the Supabase migration successfully and confirmed the existing claim record remained unchanged during verification; no title was removed as part of verification.
- **Not tested:** A live owner removal and subsequent claim by another account still needs browser/account testing.
- **Rollback:** Restore the previous `owner_manage_game_title(uuid,text)` function definition if needed.


### 2026-10-12 — Fix owner title-management visibility
- **Request:** Make sure the owner can find and use the title grant/remove controls in the Halloween Admin Panel.
- **Change:** The title-management section now refreshes whenever Admin controls are updated, including when the panel is unlocked or locked. It is shown only while the signed-in account is the owner and the Admin Panel is unlocked.
- **Files:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`
- **Verification:** Confirmed the intended visibility guard and refresh call are present in the updated source. No live browser/session test was available.
- **Commit:** `c1d88def3547abb452f9dfbdb9a87f83c89bed22`
- **Rollback:** Revert the HTML change to restore prior visibility behavior.


### 2026-10-12 — Halloween title collection and claim testing
- **Request:** Add title ownership controls for testing, a player title collection under Chat, activate/deactivate controls, and a claim-popup preview that does not consume the limited public claim.
- **Change:** Added the orange/black My Titles panel directly beneath Chat, with ownership display and active-title toggles. Active titles appear before usernames in global chat. The owner can preview the claim popup and test-claim The Spookyest without reserving the real one-time claim. The title management controls are hidden from non-owners and hidden again when the owner session ends. Owner-only Admin Panel controls can grant or remove the title for the currently selected player.
- **Claim rules:** The normal claim is an atomic server-side operation requiring 10 rebirths in the player's cloud save; only the first successful claimant reserves the title. Owner test claims and Admin Panel grants are recorded as test grants and do not reserve that claim. Test-granted titles behave normally in the collection and chat; if a qualified recipient claims the real title while it remains available, the server upgrades their record to earned ownership.
- **Server security:** Added RLS-protected title ownership, active-title preferences, and the one-time claim record, plus RPCs for atomic claim, title activation, owner-only grant/removal, and non-sensitive claim status. The owner identity is checked server-side using the existing owner email. Title RPC execution is explicitly revoked from the unauthenticated anon role and granted to authenticated users only. No service-role key was added to the browser.
- **Verification:** The three database migrations applied successfully. Inline JavaScript syntax checks passed for both script blocks; HTML checks confirmed one HTML root, balanced style/script tags, one title panel, and no new duplicate element IDs. The source already contains a duplicate `owner-player-list-admin-mode` ID; it was left unchanged as unrelated existing markup.
- **Not tested:** No browser execution or downloaded standalone Chrome-tab test has been performed yet. Please test title panel placement in a separate tab, owner preview/test claim, activation in chat, real claim race behavior with a second account, and owner grant/removal.
- **Code commits:** 10fab29dc8b291a808ec39b7ef80f149f6032c62 (feature), 1b830d55eb3ff9dcef09b8eb16f18585784608d8 (owner-only visibility safeguard), and 9dcc3690c7977fe8d38b21c140d52303fa18de63 (sidebar width alignment), and c9e06d26571bd7848d9b1c9377df5bc9a5f54e88 (hide owner controls after logout).
- **Database migration:** `add_halloween_title_collection_and_test_claims`, `allow_chat_to_display_active_titles`, `restrict_title_rpc_to_authenticated_users`, and `restrict_title_table_grants`.
- **Rollback:** Revert the HTML commit on `Halloween`; remove the title SQL objects only after confirming no other branch uses them. Do not change `game-development` or `main`.

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
