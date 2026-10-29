### 2026-10-29 — Add Chat minimize to the in-game Update Log (Halloween branch)
- **Request:** Add the latest Static Chat minimize update to the in-game Update Log.
- **Change:** Updated the player-facing latest-update date to October 29, 2026; added a concise bullet explaining the matching +/− Chat minimize control; corrected the earlier Static Chat description to say bottom-right, matching the current implementation.
- **Scope:** Only the existing editable Update Log text in the Halloween HTML was changed. No game behavior, chat logic, or saved data changed.
- **Verification:** Re-checked the targeted text anchors before writing, confirmed the updated date and both Static Chat log items, and checked balanced style/script tags. No browser UI test performed.
- **HTML commit:** `f1b56bea87c9eb363a2b8d0d35df885809f2c97b`.
- **Rollback:** Revert the HTML commit above on `Halloween` only; leave `main` and `game-development` untouched.

### 2026-10-29 — Add a matching minimize button to Static chat (Halloween branch)
- **Request:** Add a Chat minimize control matching the existing `+` / `−` buttons and avoid the recurring breakage from prior minimize-button edits.
- **HTML:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`.
- **Implementation:** Added a single `#chat-minimize-btn` beside the existing `#chat-title`; wrapped all existing chat content (but not the heading) in a unique `#chat-panel-content` wrapper. The click handler uses the same `aria-expanded`, text, accessible label, and title pattern as My Titles. It uses the wrapper's `hidden` property, without changing chat message handlers or save logic.
- **Mobile interaction:** The fixed Mobile click button's vertical offset is removed while Static chat is minimized. The minimized-state class tracks chat collapse independently from the Static chat preference, so toggling Static chat does not desynchronize the collapse state.
- **Verification:** Each HTML/CSS/JS insertion anchor was checked for a single expected match before patching; IDs are unique and style/script tag counts are balanced. HTML re-fetched after commits. No browser interaction test, JS parser test, or standalone downloaded-file test was performed.
- **HTML commits:** `de504e0fd4f50341dd09bbba6b7c930db93e1457`, then `9beb04a06a4cfc67c68d8fada4e537d9bcdd8bf3`.
- **Rollback:** Revert the second commit first, then the first commit, on `Halloween` only. Keep `main` and `game-development` untouched.

### 2026-10-29 — Refine Static chat placement and Settings toggle (Halloween branch)
- **Request:** Make the Static chat toggle in Settings match the other settings buttons and pin active Static chat to the bottom-right.
- **Change:** Added the Static chat toggle to the existing Audio/Mobile toggle CSS rule. Changed the fixed Chat panel's desktop and narrow-screen anchors from left to right; kept the viewport height/scroll behavior and Mobile button's upward offset when both options are enabled.
- **File:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html` (Halloween branch only). No chat messaging logic, local preference key, cloud save, progression, or database behavior changed.
- **Verification:** Confirmed each intended CSS replacement matched exactly once before writing; verified style/script tag counts are balanced and re-fetched the committed HTML to confirm the right-side anchors and shared Settings toggle style. No live browser visual/interaction test was performed.
- **HTML commit:** 1e62a9384e744b7ad637018d4354c2a1cc68c9ed
- **Changelog commit:** 5d722bd4e99fad61b8d296c4e33f6e743fc693bf
- **Rollback:** Revert the HTML commit above on `Halloween`; the documentation-only commit can also be reverted if needed. Do not change `main` or `game-development`.

### 2026-10-29 — Add optional Static chat setting (Halloween branch)
- **Request:** Add an optional Settings toggle to pin Chat at the bottom-left and avoid overlap with the fixed Mobile button.
- **Change:** Added `ultimateIdleClickerStaticChatEnabled` as a browser-local preference (off by default); `updateStaticChatSettingUI()` updates the toggle and body class. CSS fixes the existing Chat panel to the bottom-left, limits it to the viewport height, and moves the Mobile button upward when both options are on.
- **File:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html` (Halloween branch only). No chat messaging logic, cloud-save format, game progression, or database schema changed.
- **Verification:** Confirmed the setting toggle/handler and preference key are unique, the CSS rules exist, and HTML/style/script tag counts are balanced. No browser visual or interaction test performed; user should test Static chat alone and with Mobile button also enabled.
- **HTML commit:** 5b566fe9f76873c7dd00688c7849dc5f2bc3267d
- **Rollback:** Revert the Static chat HTML commit on `Halloween` only. Do not change `main` or `game-development`.

### 2026-10-22 — Prevent Company Market refresh timeouts
- **Request/problem:** The player reported the Company Market panel stopped loading with `Market could not refresh: canceling statement due to statement timeout`.
- **Root cause:** Supabase PostgreSQL logs showed repeated timeouts while snapshot calls waited on the single `game_company_market_state` row lock held by `company_advance_market()`. The logs also showed timeouts in snapshot subqueries while these requests were stalled.
- **Change made:** Added `pg_try_advisory_xact_lock(hashtext('company_market_advance'))` at the start of `company_advance_market()`. Concurrent calls now return immediately instead of queuing for the same market update; the active call continues and later refreshes can advance the market normally.
- **Preserved:** Market rules, investment/withdrawal balances, click balances, transaction history, and all HTML/UI are unchanged by this fix. Only the live Supabase function was updated; no game branch was changed.
- **Verification:** Live function definition re-read and confirmed the concurrency guard. A `company_market_snapshot()` smoke test returned successfully under an 8-second statement timeout. This test ran without a signed-in player identity, so an authenticated browser refresh still needs confirmation.
- **Rollback:** Restore the prior `public.company_advance_market()` function definition from Supabase history/logs. Do not change `main` or `game-development`.

### 2026-10-22 — Company Market profit/loss shows current position only
- **Branch:** `Halloween` only.
- **Request:** Do not include gains/losses from previously withdrawn clicks in the current profit/loss display.
- **Database change:** Replaced `public.company_market_snapshot()`. It walks the signed-in user's Company Market transaction history in timestamp/ID order, adds investment amounts to cost basis, and proportionally removes weighted-average cost basis on withdrawals. `net_profit_loss` is now current share value minus remaining cost basis; `total_invested` is returned as the remaining cost basis for the UI. No stored investment rows or transactions were changed.
- **HTML change:** Renamed “Total clicks invested” to “Current investment cost” and updated the explanatory text to state that historical withdrawn gains/losses are excluded.
- **Compatibility:** Kept existing RPC name and response keys; no schema migration was added. This relies on the transaction ledger having the user's investment and withdrawal history.
- **Verification:** Supabase accepted the function replacement. Source patch is narrow and does not change game mechanics or saved player progress. Real signed-in browser test has not yet been performed.
- **Rollback:** Restore the previous `company_market_snapshot()` definition from the preceding changelog entry, and revert the HTML/documentation commits for this change. Halloween branch only; do not touch `main` or `game-development`.

### 2026-10-22 — Keep Company Market profit/loss display in sync (Halloween branch)
- **User request:** Fix the Overall profit/loss section because its displayed information appeared incorrect.
- **Investigation:** The live `public.company_market_snapshot()` function returns `my_value`, `total_invested`, `total_withdrawn`, and `net_profit_loss = current share value + total_withdrawn - total_invested`. The withdrawal RPC increments `total_withdrawn` in the same transaction that adds the withdrawn clicks to the cloud save; the investment commit increments `total_invested`. This formula is consistent with nominal profit/loss including withdrawals.
- **Root cause found in the UI refresh path:** `refreshCompanyMarket()` returned immediately when another market snapshot or investment was in progress. A refresh requested after a transaction could be discarded if an older snapshot was still running, leaving the displayed personal values temporarily stale.
- **Change made:** Added `companyMarketRefreshQueued`. A refresh request received during an active snapshot or investment is queued, then a fresh snapshot is run when the active operation finishes and no investment is in progress. The existing database formula and all investment mechanics were left unchanged.
- **File/functions touched:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`; the declaration and `refreshCompanyMarket()`.
- **Preserved:** Supabase schema and RPC definitions, cloud-save protections, investment/withdrawal logic, market math, UI layout, and save compatibility.
- **Verification:** Committed to `Halloween` as HTML commit `5321933a2558ab309343b91647d0baf7bd5d1df6`. Source was re-fetched and checked for one refresh function, queued refreshes on contention, and the follow-up refresh in `finally`. Changelog updated in commit `455f8b809e8fb7e457be89f4794c5a40362f71c9`.
- **Not tested:** No live browser, real-account investment/withdrawal, or display timing test was performed. The change addresses the confirmed dropped-refresh path, but user confirmation is still needed that the values now match after transactions.
- **Rollback:** Revert HTML commit `5321933a2558ab309343b91647d0baf7bd5d1df6` on `Halloween`; revert documentation commit `455f8b809e8fb7e457be89f4794c5a40362f71c9` if removing its changelog entry. Do not change `main` or `game-development`.

### 2026-10-22 — Retry transient cloud-sync contention before company investments (Halloween branch)
- **User report:** every investment attempt failed with “Your latest progress could not be safely synced. Load the latest cloud save if a conflict was reported, then try again.”
- **Root cause scope:** the message was thrown whenever the pre-investment `cloudSaveGame(false, true)` returned false. That function can return false not only for a real stale-cloud conflict, but also when another cloud load/save is already in progress. The investment path previously treated both cases as an immediate failure. A real cloud conflict remains intentionally guarded to prevent overwriting newer progress.
- **Change made:** the investment path now waits for an active load/save to finish and retries the guarded sync up to four attempts. A detected cloud conflict produces a specific message instructing the player to use “Load from Cloud”; persistent busy state produces a retry-later message. Both stop before click reservation.
- **Files/functions touched:** Halloween HTML, `beginCompanyInvestment()`, plus the in-game Update Log.
- **Preserved:** cloud compare-and-swap conflict protection, named-save confirmation, investment reservation/refund safeguards, market formulas, and save schema. No database changes.
- **Verification:** re-fetched HTML and checked the new retry loop, conflict checks, no-clicks-reserved messages, and Update Log entry. No standalone-browser test or authenticated investment test was performed; the original user-reported issue is not confirmed fixed until a real investment is tested.
- **HTML commits:** `c83bc4e195f8c6c38b96c9fb8ddd71eeea0e1901` and `ed92c7998e5ac60d35c4af6fd7dd604882fa00b4`.
- **Rollback:** revert `ed92c7998e5ac60d35c4af6fd7dd604882fa00b4`, then `c83bc4e195f8c6c38b96c9fb8ddd71eeea0e1901` on `Halloween` only. Do not change `main` or `game-development`.

### 2026-10-22 — Show personal Global Company investment cost and profit/loss (Halloween branch)
- **User request:** show what a player originally invested and the current value, so they can tell whether they are ahead or behind.
- **HTML:** added rows for total clicks invested, current investment value, and overall profit/loss; positive results display green and negative results red. Updated the explanatory note. Logout clears the added personal values.
- **Calculation:** `net_profit_loss = current share value + total_withdrawn - total_invested`. This correctly includes value already returned by partial/full withdrawals. The database already tracks cumulative `total_invested` and `total_withdrawn` per player.
- **Supabase:** extended only the JSON response from `public.company_market_snapshot()` to return `total_invested`, `total_withdrawn`, and `net_profit_loss`. No tables/columns, policies, investment rules, or market calculations changed. Re-fetched the function definition and verified the fields/formula are present.
- **HTML commit:** `b200a289065d53ad45d980b4e889e266a2db5132`.
- **Testing:** source edits and backend function definition verified. No standalone-browser visual test or real-account invest/withdrawal test performed.
- **Rollback:** revert HTML commit `b200a289065d53ad45d980b4e889e266a2db5132` on `Halloween`; separately restore the previous `company_market_snapshot()` function definition if the backend change must be undone. Do not change `main` or `game-development`.

### 2026-10-22 — Reduce failed Global Company investments (Halloween branch)
- **User report:** other players are struggling to invest.
- **Investigation:** Supabase logs showed repeated `company_commit_investment` errors: “Your cloud save changed while confirming.” The flow reserved clicks before opening the blocking prompt to name/replace a named save. A long prompt could leave the reservation pending while another tab/device changed the cloud save, causing the database's concurrency guard to reject the commit.
- **HTML change:** moved the name/replace prompts before reservation. After the prompts, the game attempts a second guarded cloud sync and rechecks the named-save fields. If the cloud save or named save changed, the attempt aborts before any clicks are reserved. If unchanged, the reservation and commit happen consecutively, reducing the window for conflicts.
- **In-game Update Log:** added a brief entry about the safer investment confirmation order.
- **Supabase/database:** no database functions, tables, policies, or schema were changed.
- **HTML commits:** `2624510ddc8d5d9cb81de8f949ac7b2ef8ce76ea` (flow change), then `84a2e206ca19a07131cc2a1b631a6d9f3c0e540a` (clarify that clicks are not reserved until prompts are finished).
- **Docs commits:** `966ba5c41c6d98e054ca804e7f5d148ae4a28503` (changelog), `8a6d4741648ef605f8b2269af9648d0cd37896f0` (development log), and `55ba529a1c070c843b9ceb5765c0a5109f1277cb` (changelog rollback/update details).
- **Verification:** fetched the committed HTML again; checked the name and replacement prompts precede `company_begin_investment`, the second cloud sync is before reservation, the existing commit/cancel flow remains present, the in-game log entry exists, and Global Company remains above Bank. No browser/standalone test or live investment test was performed.
- **Rollback:** revert HTML commit `84a2e206ca19a07131cc2a1b631a6d9f3c0e540a`, then `2624510ddc8d5d9cb81de8f949ac7b2ef8ce76ea`, followed by the docs commits `55ba529a1c070c843b9ceb5765c0a5109f1277cb`, `8a6d4741648ef605f8b2269af9648d0cd37896f0`, and `966ba5c41c6d98e054ca804e7f5d148ae4a28503`, on `Halloween` only. Do not change `main` or `game-development`.

### 2026-10-22 — Force company collapse controls to show symbols (Halloween branch)
- **User report:** company buttons still visibly said “Minimize” rather than showing plus/minus symbols.
- **Change:** added scoped CSS for `.company-market-panel .company-collapse-btn` that sets text-node font size to zero and renders a CSS `::before` symbol based on `aria-expanded`: minus when expanded, plus when collapsed. This makes the visible label independent of stale/overridden button text while preserving the existing click handlers and accessible title/aria-label.
- **HTML commit:** `776d4ed244b94c37b116449b2730bf21b6994cf6`.
- **Verification:** commit succeeded. Re-fetch and source-level checks still required; no real browser visual test performed.
- **Rollback:** revert `776d4ed244b94c37b116449b2730bf21b6994cf6` on `Halloween` only; do not change `main` or `game-development`.

### 2026-10-22 — Match company collapse buttons to Titles panel (Halloween branch)
- **Request:** make the Global Company and Market activity minimize buttons look like the existing My Titles minimize button.
- **Changes:** changed the company button CSS to the same compact fixed 28×28 square treatment used by `.titles-panel-heading .titles-minimize-btn` (inline-flex, fixed dimensions, padding 0, #65452f border, #35251c background, 6px radius, inherited text color, bold 1rem glyph). Both controls now display `−` while expanded and `+` while collapsed. Updated aria-label and title attributes with the current action.
- **Preserved:** collapse content and handlers, investment/market logic, and panel placement. No database changes.
- **HTML commit:** `4b323ac7ecf919c78c5e79c449a471562ace836d`.
- **Verification:** source checks confirmed unique toggle IDs, plus/minus state updates, accessible labels, and Global Company placement above Bank. Real-browser appearance/clicking remains untested.
- **Rollback:** revert `4b323ac7ecf919c78c5e79c449a471562ace836d` on `Halloween` only; do not change `main` or `game-development`.

### 2026-10-22 — Add Global Company Market collapse controls (Halloween branch)
- **Request:** allow players to minimize the entire Global Company panel and independently minimize Recent market events plus the company-related content below it.
- **HTML changes:** added `#company-market-toggle` outside `#company-market-content` so the heading stays visible when the main contents are collapsed. Added `#company-market-activity-toggle` for the combined `#company-market-activity-content` wrapper, which contains recent events, anonymized transaction summaries, and owner controls. Both controls update `aria-expanded` and their button labels. Both sections default to expanded. Added scoped CSS for compact controls and an explicit `[hidden]` rule so the activity wrapper's display style cannot override the collapsed state.
- **Compatibility/layout:** no market RPCs, investment logic, save logic, existing market element IDs, Bank placement, or database schema changed. The Global Company panel remains above the Bank.
- **In-game Update Log:** added an entry describing both collapse controls.
- **HTML commits:** `c6b5b71ecf415921d91ce8ac70596dfa791decbe`, then `ab5589b9c80a579e198d8b904d02b197c9d3274a` (CSS hidden-state correction).
- **Verification performed:** structural source checks confirmed each toggle and content wrapper ID appears once, the market panel precedes the Bank, and the event list, transaction summary, owner controls, and in-game Update Log entry remain present. The CSS hidden-state override was corrected after source review. No browser/standalone interaction test was performed, so actual clicking and visual appearance still need user testing.
- **Rollback:** revert `ab5589b9c80a579e198d8b904d02b197c9d3274a` first, then `c6b5b71ecf415921d91ce8ac70596dfa791decbe`, on `Halloween` only. Do not change `main` or `game-development`.

### 2026-10-22 — Global Company Market implementation (Halloween branch)
- **User requirements:** one shared global company; player investments only/no artificial starting capital; any positive investment amount; market value changes with elapsed time and market performance rather than separate guaranteed interest; hybrid unpredictable events, investor inflow/outflow pressure, and inflation; inflation reduces displayed purchasing power and influences market performance; withdrawals allowed at any time; major crash events lose at most 90%, with an extremely rare total-loss catastrophe; public market index/trend, total value, inflation, chart, event history, and anonymized transaction summaries; market panel above Bank; named-save confirmation required for every investment; owner-only market reset, inflation increase, forced drop, and pause/resume controls.
- **HTML implementation:** added `#company-market-panel` before `#bank-panel` inside the existing left sidebar, plus scoped Halloween styling, SVG history chart, event/transaction lists, investment/withdrawal controls, owner controls, and a busy overlay. Existing main-click, auto-click, local autosave, and cloud-save actions are paused during the investment reservation/confirmation flow so clicks do not change while the named-save confirmation is pending. The panel also clears personal investment values on logout and ignores a market response that belongs to a previously signed-in account.
- **Investment flow:** first cloud-save current progress with compare-and-swap protection; server-side RPC reserves the requested clicks and records a pending transaction; the player must name/update the existing single named save; one database transaction then writes the new named save and normal save snapshot, adds shares, records the transaction, and commits the pending reservation. Cancel or failed confirmation calls the cancel RPC; expired pending reservations are automatically refunded when the market is next refreshed. Pending reservations carry the save reset version so a hard reset cannot be followed by an unintended refund into the reset save.
- **Withdrawal flow:** synchronize current progress, then the server-side withdrawal RPC validates available share value, updates the cloud save's clicks, reduces shares, records the transaction, and returns the authoritative amount. The client then updates its current clicks and sync timestamp.
- **Database:** Supabase project `itriqucjgayokvddrbxm`; migration `global_company_market_v2` created `game_company_market_state`, `game_company_investments`, `game_company_pending_investments`, `game_company_transactions`, and `game_company_market_history`. Server functions include `company_market_snapshot`, `company_begin_investment`, `company_commit_investment`, `company_cancel_investment`, `company_withdraw`, `company_market_admin_action`, and internal market/refund helpers. Direct client access to these tables is revoked; RLS is enabled. Follow-up SQL hardening records each pending investment's cloud reset version to avoid refunding clicks after a hard reset, and stores an immutable `owner_user_id` on the market row seeded from the existing owner admin record so future admins cannot gain company emergency controls. The UI only displays controls for the existing owner email; the server-side owner check is authoritative.
- **Market model:** baseline index 100 is a price baseline, not starting capital. Share count determines each player's claim; the aggregate nominal pool is shares multiplied by the current index. Market drift scales with elapsed time, recent net withdrawals create downward pressure, inflation grows gradually and can spike during downturns/crashes, daily event probability produces booms/downturns/crashes, and the catastrophic event is configured at a 0.05% chance among market events. Catastrophe zeroes existing shares, records the event, and reopens the market at index 100 with no artificial capital. Manual crash controls cap drops at 90%. Owner reset rescales shares to preserve each player's current nominal value and leaves inflation unchanged.
- **HTML commits:** `76250b8cc16a1db0ddbbd5b72455517f8496cfa5`, `2ae86f1e5cfe4dc7189ec090ac6fbb6d1ea2cbb4`, `e2487cd80001422fbd1179995ecc4ccedaa67a7e`, `934940707a69a49fd814b2b0ad9929cbf7997c10`.
- **Verification performed:** Supabase migration applied; follow-up SQL hardening applied; snapshot RPC executed successfully and returned index 100, inflation index 1, total pool 0, and no investors. SQL permission checks confirmed anonymous callers can read the public snapshot but cannot execute the investment RPC. HTML was re-fetched after the final commit; the company panel precedes the Bank, the new controls and RPC calls are present, the in-game Update Log entry is present, and the existing main HTML remains the same source file. No authenticated investment or withdrawal was run against a real player account; no real browser/standalone/mobile/cross-device test was performed.
- **Known limitations / next test:** The market advances when a client requests a snapshot, with elapsed time applied by the server; it is not driven by a separate scheduled background job. Test the first real investment, cancel/refund, overwrite-confirmation, partial/full withdrawal, reset-version protection, owner controls, and cross-device reload before treating the feature as production-ready. Supabase advisors flag intentionally exposed security-definer RPCs (the public snapshot for public market data and authenticated transaction RPCs) and RLS-enabled tables without direct policies. These tables intentionally have no direct client policies because all operations use the checked RPCs; re-run advisors after any future permission change.
- **Rollback:** revert the four HTML commits above in reverse order on `Halloween` only, starting with `934940707a69a49fd814b2b0ad9929cbf7997c10`. Do not drop the Supabase tables/functions during rollback, because committed investor balances and transaction history must be preserved. The game branch can hide the feature while its server-side data remains available for safe recovery/re-enable. Never modify `main` or `game-development`.

### 2026-10-21 — Add optional fixed Mobile button (Halloween branch)
- Added a **Mobile button** On/Off option to Settings, styled like the existing Goofy Audio option. When enabled, a separate **CLICK!** button appears fixed near the lower-right corner of the screen, so it remains in place while the page scrolls.
- The floating button calls the existing main-click routine, preserving normal click rewards, multipliers, admin click buffs, UI updates, and the existing click sound setting. The preference is saved in this browser using localStorage and defaults to Off; if storage is unavailable, it remains off by default.
- **HTML commit:** 4f87af8e4efd1dab33c7d4bc45564c62b13c6683.
- **Verification:** Re-fetched the committed HTML and checked the settings row/toggle, fixed-position CSS, local preference persistence, and connection to the shared main-click routine. Actual mobile-browser interaction and scrolling still need user testing.
- **Rollback:** Revert HTML commit `4f87af8e4efd1dab33c7d4bc45564c62b13c6683` on `Halloween` only. Do not change `main` or `game-development`.

- **Implementation detail:** Added `#game-settings-mobile-row`, `#game-settings-mobile-toggle`, and `#mobile-click-button`; the floating control uses `position: fixed` and is hidden until enabled. Toggle state uses `ultimateIdleClickerMobileButtonEnabled`; the floating button invokes `performMainClick()` rather than duplicating game mechanics.
- **Scope/regression notes:** No save format, Supabase, progression, or existing main-button handler changes. Browser-level mobile/touch testing was not available. If a regression appears, revert the HTML commit above and then revert the corresponding documentation entries.
### 2026-10-21 — Default Goofy Audio to Off
- Changed Goofy Audio to start Off unless the player has explicitly saved an On preference in this browser. The Settings toggle also initially displays Off, and browser-storage failure safely leaves audio disabled.
- **HTML commit:** fec24a0d4d13c89d0fcc2ac07a9b2d36907f3a6f.
- **Verification:** Confirmed the expected default-setting code and initial toggle markup before editing; follow-up fetch checks pending. Browser testing still needs user confirmation.
- **Rollback:** Revert HTML commit `fec24a0d4d13c89d0fcc2ac07a9b2d36907f3a6f` on `Halloween` only. Do not change `main` or `game-development`.

### 2026-10-21 — Add Goofy Audio setting
- Added a fixed Settings button directly beneath the Menu button so both stay anchored to the screen. Settings opens a compact panel with a Goofy Audio On/Off toggle.
- Turning Goofy Audio off prevents new click/purchase sounds and stops any sound currently playing. The preference is saved in this browser using localStorage and defaults to On.
- **HTML commit:** 42fe7c8248042c631ed0c0963afe00be188a8eaf.
- **Verification:** Source anchors were checked before editing and the updated HTML was committed to `Halloween`; follow-up fetch and source checks pending. Browser interaction/audio testing still needs user confirmation.
- **Rollback:** Revert HTML commit `42fe7c8248042c631ed0c0963afe00be188a8eaf` on `Halloween` only. Do not change `main` or `game-development`.

### 2026-10-21 — Prevent sound effects from restarting before they finish
- Changed click and purchase sound playback so a sound already playing ignores additional requests until it finishes. Each sound still uses one reusable audio player; no overlap, restart, silence detection, or player pool.
- **HTML commit:** 066d61f714558941f078354d18c2969cbb3b2ec2.
- **Verification:** Confirmed the prior sound helper matched before editing and the update committed on `Halloween`. Source-level behavior checked; actual browser playback still needs user confirmation.
- **Rollback:** Revert HTML commit `066d61f714558941f078354d18c2969cbb3b2ec2` on `Halloween` only. Do not change `main` or `game-development`.

### 2026-10-21 — Restore sound after silence-detection regression
- **Report:** User said all game sounds became silent after the experimental silence detector was added.
- **Fix:** Removed Web Audio analyser routing and the silence-skipping monitor. Restored one reusable audio player per sound, with each request pausing, rewinding, and replaying it. This prioritizes restoring audible sound and avoids overlapping player pools; automatic silence skipping is temporarily disabled.
- **Verification:** HTML commit succeeded on `Halloween`. A source check should confirm the Web Audio analyser code is absent and the normal `audio.play()` path remains. Real browser/device sound playback still needs user confirmation.
- **HTML commit:** `66376fc4e6974ffe8dee0f003253f39ae370b9e0`.
- **Rollback:** Revert that HTML commit on the `Halloween` branch only. Do not change `main` or `game-development`.

### 2026-10-21 — Skip silent gaps in sound effects
- **Request:** Skip silent parts during playback without editing/trimming the MP3 files, while avoiding the lag and doubled audio caused by overlapping player pools.
- **Implementation:** In `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`, restored one reusable audio player per sound. A new request restarts the matching player from the beginning. Added a Web Audio analyser to detect sustained near-silence (RMS below 0.012 for at least 100 ms); during such gaps it seeks forward in 0.18-second increments. The analyser is set up lazily, and playback falls back to normal if Web Audio analysis is unavailable.
- **Assets and gameplay:** No MP3 files, click/purchase sound call sites, game mechanics, or save data were changed.
- **Verification:** Confirmed the original helper boundaries were found before replacing the sound function and the HTML update committed successfully. This is source-level verification only; actual playback quality, browser support, and whether the threshold skips the intended gaps must be tested in the browser.
- **HTML commit:** `383cc4ff334474ef01a6305eab99aaac21103dca`.
- **Rollback:** Revert that HTML commit on the `Halloween` branch only. Do not change `main` or `game-development`.

### 2026-10-21 — Allow overlapping sound effects
- **Request:** The user wanted a fresh sound to begin on each press even when the previous instance had not finished, rather than restarting the same sound and cutting off its quiet gaps.
- **Fix:** Use a reusable pool of up to 8 audio players per sound. Each request uses an idle/finished player or creates one until the pool is full, allowing sound instances to overlap. Once all players are busy, recycle the oldest player instead of growing the pool without limit.
- **File:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`.
- **Verification:** Source-level check confirms the overlap pool and cap are present. Actual browser/device audio and performance testing is still required.
- **HTML commit:** `12c3fa783ae2547c0de531eef8cc7f3b0c0e1036`.
- **Rollback:** Revert that HTML commit on `Halloween` only. Leave `main` and `game-development` untouched.

### 2026-10-21 — Restart sounds on every press
- **Issue:** The prior lag-reduction behavior skipped click sounds whenever the player was already playing, so repeated presses did not each trigger a sound.
- **Fix:** Keep one reusable preloaded audio player per sound, set its playback position to the beginning for each request, and call play again. This avoids allocating additional audio objects while allowing a new press to restart the current sound. A seek attempt is guarded for cases where the file is not yet seekable.
- **File:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`.
- **Verification:** Source-level check confirms the active-playback skip was removed and sound players are still reused. No live browser/device playback or performance test was available.
- **HTML commit:** `18644bc4f8bee6f6f7dd7398ca8a5a785aa9d358`.
- **Rollback:** Revert that HTML commit on `Halloween` only. Leave `main` and `game-development` untouched.

### 2026-10-21 — Reduce lag from rapid sound playback
- **Issue:** After the duplicate-sound fix, the user reported severe game lag.
- **Cause addressed:** The helper paused, rewound, and restarted the same audio element on every accepted click. Doing those operations repeatedly during rapid clicking can cause expensive audio work.
- **Fix:** Keep one preloaded audio player per sound. If the player is already playing, skip another playback request rather than seeking/restarting or overlapping it. The click handler and earned clicks are unchanged; only sound requests during an existing playback are skipped.
- **File:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`.
- **Verification:** Source review confirmed the repeated pause/rewind/play path is removed and the reusable player is loaded once. Device/browser performance is not directly testable here; user confirmation is still required.
- **HTML commit:** `e41bd38d9d1702313067922e0919ba7871147a44`.
- **Rollback:** Revert that HTML commit on `Halloween` only. Leave `main` and `game-development` untouched.

### 2026-10-21 — Prevent duplicate and stacked sound playback
- **Issue:** The user reported that one main-button press still played the click sound twice and that rapid clicking caused performance problems after the previous mobile touch fix.
- **Cause addressed:** The sound helper constructed a brand-new `Audio` object on every invocation and allowed very closely spaced duplicate requests to play. This could create overlapping audio players and extra playback work. The earlier touch fix only addressed one suspected mobile event path and did not address audio-player accumulation.
- **Fix:** Reuse one audio player per sound; pause and rewind it before replaying so fast clicks do not stack multiple players. Ignore repeat calls for the same sound within 40 ms to suppress duplicate sound triggers from one interaction. This guard affects sound only, not click earnings or click-event handling.
- **File:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`.
- **Verification:** Re-fetched the current Halloween HTML and both MP3 assets; checked the updated helper in source. No live browser/device test was available, so the user's playback report is still needed to confirm the result.
- **HTML commit:** `e9f410f393e008a785caca2da5eddd3e5a70a7a9`.
- **Rollback:** Revert that HTML commit on `Halloween` only. Leave `main` and `game-development` untouched.

### 2026-10-21 — Fix duplicate mobile main-button click
- **Issue:** On mobile, one tap could run the direct `touchend` main-button handler and then also let the browser's synthetic `click` reach the main-button listener. That caused duplicate click processing and could play the click audio twice.
- **Fix:** In the document-level capture handler, stop propagation of the synthetic click only when the already-handled mobile target is `click-btn`. Other buttons retain the existing fallback behavior.
- **File:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`.
- **Verification:** Checked the exact event flow and confirmed the change is limited to the duplicate main-button synthetic click. Live mobile playback/performance testing was not available.
- **HTML commit:** `153569a0d12bc6b003296fa7923371e886b6c89c`.
- **Rollback:** Revert that HTML commit on `Halloween` only. `main` and `game-development` were not changed.

### 2026-10-21 — Add click and purchase sounds on Halloween
- **Request:** Play `Click 1.mp3` on each main-button click path and `Purchase 2.mp3` when an upgrade purchase succeeds.
- **Change made:** The game uses relative asset paths beside the HTML file. The shared `performMainClick()` routine plays the click sound, covering normal button clicks, Space-key clicks, and each Silent Clicking action. Eight upgrade purchase functions play the purchase sound only when at least one upgrade was bought. Audio volume is 45%.
- **Files:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`, `Click 1.mp3`, and `Purchase 2.mp3`; this entry also updates project documentation.
- **Verification:** Fetched the HTML and both MP3 assets from the `Halloween` branch; confirmed exact filenames and current blob SHAs. Static source review found one shared click-sound call and eight successful-purchase sound call sites. No browser/audio playback test was performed.
- **Not tested / user testing needed:** Open the Halloween game with both MP3 files in the same folder (or use the Halloween hosted page), then test a click, Space, Silent Clicking, and a successful upgrade purchase. Browser audio restrictions or file placement may still prevent playback.
- **HTML commit SHA:** `44a2b9f5619830ef94cd07c845ffe8a41ef531ab`.
- **Asset SHAs:** `Click 1.mp3` — `b97a800fc132a0911cdfa1ec7d27bbd122d0e23e`; `Purchase 2.mp3` — `0ccf5eb7486a00828d845db8cfde66e5e3bd1332`.
- **Rollback instructions:** Revert the HTML commit on the `Halloween` branch. Do not revert/delete the assets unless intentionally removing sound support. `main` and `game-development` were not changed.

### 2026-10-21 — Long-term multi-announcement board
- **Request:** Make announcement text larger, support multiple persistent notices, allow deleting a notice by clicking it and confirming, and give the panel a more permanent look.
- **Change made:** Styled the panel as a long-term notice board with larger text and pinned announcement cards. Added an owner-only “Add a Long-Term Announcement” editor. Each announcement stays published until individually deleted through a confirmation prompt. New notices and deletions reload the list and broadcast updates through Supabase Realtime.
- **Database:** Added `public.game_announcements` with RLS, public read access, and owner-only insert/delete policies; migrated any current non-empty message from `game_global_announcement`. Explicitly limited table grants to read for `anon`/`authenticated` and insert/delete for `authenticated`.
- **Files:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`, `CHANGELOG.md`, `DEVELOPMENT_LOG.md`.
- **Verification:** Both JavaScript blocks compile; no duplicate IDs; div/details/form/textarea/button/script/style counts are balanced; required editor, table references, and delete-confirmation code are present. Database policy names/commands were checked. No live browser test was performed.
- **HTML commit:** `6bcb2ec41c5dc2fed2fcf534c4afb9ab9dfc809f`.
- **Rollback:** Revert the HTML commit on `Halloween`; leave the database table in place unless a separate database rollback is deliberately planned. `main` and `game-development` were not changed.

### 2026-10-21 — Move announcement editing to the login panel
- **Request:** Let the owner write announcements from the login Announcements section and prevent those announcements from appearing in the gameplay area.
- **Change made:** Moved the existing announcement text box, Publish, Clear, and status message into the left-side login Announcements panel. The editor is shown only when the signed-in account matches the existing owner account. Removed the separate in-game announcement banner and updated the shared renderer to update only the login-menu announcement text.
- **Database:** Reused `game_global_announcement` and existing owner-only save validation/realtime subscription; no database changes.
- **Files:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`, `CHANGELOG.md`, `DEVELOPMENT_LOG.md`.
- **Verification:** Confirmed the edit anchors before replacement. Post-edit source checks are recorded after fetching the committed HTML. No live browser or multi-account test was performed.
- **HTML commit:** `5922407a3323ba21b2c0983d6d4496032d1851ef`.
- **Rollback:** Revert HTML commit `5922407a3323ba21b2c0983d6d4496032d1851ef` on `Halloween`; no changes to `game-development` or `main`.

### 2026-10-21 — Add always-visible login announcements
- **Request:** Add announcements to the left side of the login menu and keep the panel open/visible by default so players notice it.
- **Change made:** Added a permanently visible orange/black Announcements panel to the left of the centered login card on desktop. It displays the current global announcement or a friendly empty-state message. On screens at or below 1000px wide, it stacks below the login card to avoid squeezing the center card. The existing in-game global announcement renderer now updates both the gameplay banner and login-menu panel.
- **Database:** Reused the existing `game_global_announcement` row and owner-only publishing flow. No database/schema/policy changes.
- **Files:** `Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`, `CHANGELOG.md`, `DEVELOPMENT_LOG.md`.
- **Verification:** Confirmed the expected HTML/CSS/function anchors before making replacements. No live browser or narrow-screen visual test was performed.
- **Commit:** HTML `01626c8046efa10f7be2448b14b4aeff3fbdd132`; documentation commits recorded in GitHub after this entry.
- **Rollback:** Revert HTML commit `01626c8046efa10f7be2448b14b4aeff3fbdd132` on `Halloween`. No changes to `game-development` or `main`.

### 2026-10-21 — Add Pulls player voting
- **Request:** Add a Pulls button beneath Suggestions where the owner can release a poll and players can vote for an option.
- **UI:** Added a collapsible Pulls panel under Suggestions. Owner-only form accepts a 3–240 character question and 2–8 unique options (one per line, up to 120 characters each). Only one poll can be active at once; owner closes voting before releasing another. Players must be signed in, can vote once per poll, and see counts/percentages and closed-poll results. Added manual Refresh Results.
- **Database:** Added `game_polls`, `game_poll_options`, and `game_poll_votes` with RLS. The primary key on (poll_id,user_id) enforces one vote per account per poll; composite FK ensures the selected option belongs to that poll. A partial unique index limits active polls to one. `get_game_poll_results()` exposes aggregate counts only and is executable by authenticated users, not anon. Vote rows are readable only by the voter. Owner-only writes are restricted using the same verified owner-email claim used by existing game policies.
- **Verification:** Supabase confirms all three tables have RLS enabled and policies; the aggregate function is not executable by anon. Both inline JavaScript blocks compile, no duplicate IDs found, and expected UI/update-log elements are present.
- **Not tested:** No live browser, multiple-account, or end-to-end voting test was run. Owner should test creating a poll, voting from another account, duplicate-vote prevention, closing a poll, and releasing the next one.
- **HTML commits:** `b2f5a1df9d6faf366fd7d66d04c549f8846f46bd` (Pulls UI/logic), `09a5658348276697a733132c0497880609606c87` (Refresh Results).
- **Supabase migrations:** `add_player_polls_and_votes`; `qualify_poll_vote_policy`.
- **Rollback:** Revert the two HTML commits on `Halloween`; drop the three poll tables and aggregate function only if the feature is intentionally removed, via a reviewed migration. Do not touch `game-development` or `main`.

### 2026-10-21 — Refresh in-game player-facing Update Log
- **Request:** Update the actual Update Log players see in the game, not only project documentation.
- **Change:** Listed the login screen, Update Log and Suggestions panels, Log Out button, centered desktop menu card, Insomniac title, and $$$ title. Unlock conditions remain secret in the player-facing log.
- **Verification:** Confirmed the exact title spelling and the editable Update Log block in the committed HTML.
- **HTML commit:** `ca02b645600425c8414f0888884dfd9504e353c0`.
- **Scope:** Halloween branch only; no gameplay, authentication, saving, or database logic changed.

### 2026-10-21 — Keep login/menu card centered
- **Request:** Ensure the main menu card stays centered even with the Update Log and Suggestions panels beside it.
- **Change:** Changed `#game-entry-layout` to use the login card’s own centered width; the desktop sidebar is positioned outside that width, so it does not shift the card’s horizontal center. At the 850px breakpoint, the sidebar becomes normal-flow content beneath the card.
- **Preserved:** Existing login/logout handlers, auth/session flow, save logic, and panel content unchanged. Suggestions remains below Update Log in the sidebar; expanded Update Log pushes it down rather than overlapping.
- **Verification:** Re-fetched committed HTML; confirmed one `game-entry-layout` wrapper, centered-width CSS, absolute desktop sidebar, mobile normal-flow sidebar, and balanced HTML/style/script tag counts (1/1, 6/6, 3/3).
- **Not tested:** No live browser/standalone Chrome visual test performed. User should confirm desktop card centering and mobile stacking.
- **Commit:** `37b1ec0250261abbdf59a126e4ddfc387dfb699a` (HTML).
- **Rollback:** Revert this HTML commit on `Halloween` only; do not touch `game-development` or `main`.

### 2026-10-21 — Align sidebar top with login card
- Fixed vertical alignment by adding `#game-entry-layout` as a flex wrapper around the login/menu card and the right sidebar. Wrapper is centered in the gate, with children aligned to the top edge; this reproduces the original Update Log placement next to the login card rather than pinning the sidebar to the top of the viewport.
- Sidebar details remain normal-flow, so opening Update Log pushes Suggestions down. Mobile breakpoint still stacks sidebar beneath the card. Log Out button and all auth/game/save logic unchanged. Static verification and browser test status to be recorded after commit.

### 2026-10-21 — Restore right-side login/menu sidebar
- User preference: Update Log and Suggestions should remain to the right of the login/menu card on desktop, while expanded details must not overlap Suggestions. Kept game-menu-logout unchanged beneath Resume Game.
- HTML: moved both details elements into #game-entry-sidebar; desktop gate uses a horizontal flex row, sidebar width 250px; under 850px it stacks below the card. Both details remain normal-flow elements so opening Update Log pushes Suggestions down.
- No auth/session, game save, title, or database logic changed. Static source checks pending after commit; browser layout testing remains pending. Rollback: revert the focused HTML commit on Halloween.

### 2026-10-21 — Menu logout and login panel layout fix
- Added `game-menu-logout` below Resume Game, delegates to existing `cloud-logout-btn` click handler (no duplicated logout flow). Replaced absolute positioning of `#game-update-log` and `#game-suggestions` with normal vertical flow, ensuring open details push later sections down on desktop and mobile. Halloween HTML commit `67433d1ad098c9feba199ee9798553a5978e0e1a`; source verified, browser testing pending. Revert that HTML commit to roll back.

### 2026-10-21 — In-game menu access
- Halloween HTML only: `game-menu-open` body class reuses login overlay for signed-in users, hides login controls and shows Resume Game; fixed ☰ Menu button allows mobile/touch access. Esc toggles menu unless an input or visible dialog is active; logout clears menu state through updateCloudUI. No changes to auth/session, saves, or database. Revert HTML commit `5be09ab9e31f1aa0e04d330b8a7cb504031e6d5e` for rollback. Source verification completed; browser/device testing pending.

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

