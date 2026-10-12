# Ultimate Idle Clicker — Development Rules and Absolute Laws

These rules are the project's permanent editing contract. Read this file before changing the game. They exist so work can continue across ChatGPT conversations without relying on chat history or hitting conversation/file limits.

## 1. Source of truth and branch safety

1. The current game HTML on the `game-development` branch is the source of truth for development. Fetch and inspect the current GitHub file before every edit; do not assume an older download is current.
2. Make game changes directly in this repository: https://github.com/27nelsonc-oss/Ultimate-Idle-Clicker
3. Work on `game-development` only unless the user explicitly authorizes another branch.
4. **Never change, merge into, or replace `main` without explicit user authorization.** Keep the existing/main game intact.
5. GitHub workflow must remain optional for the user's normal download-and-test workflow. Do not remove or break the ability to download and open the standalone HTML.
6. Before writing, check the current branch, file path, and current blob SHA. If the source has changed since it was inspected, fetch it again before updating.
7. Do not claim a GitHub edit is complete until the commit and resulting file have been verified.

## 2. Minimal-change rule

1. Implement only the specific change requested by the user, plus the smallest supporting changes genuinely necessary for it to work.
2. Do not redesign, rewrite, reorganize, refactor, simplify, or clean up unrelated code.
3. Do not remove or alter existing features, mechanics, visual styling, UI placement, save formats, or player data unless explicitly requested or strictly necessary for the requested fix.
4. Preserve existing IDs, function names, event bindings, CSS selectors, storage keys, Supabase schema expectations, and compatibility unless the task requires a deliberate change.
5. Avoid broad replacements and speculative fixes. Trace the relevant flow and patch the narrow cause.
6. Do not add extra features just because they seem useful. If a broader change appears necessary, explain why and ask before expanding scope.
7. The user is the game designer and idea planner. Help implement the user's vision; do not take over design decisions.

## 3. Required workflow for every game edit

1. Restate the exact requested outcome internally and identify what is explicitly out of scope.
2. Inspect the current source and the relevant HTML, CSS, JavaScript, storage, authentication, and event flows before editing.
3. Identify the likely root cause and make the smallest viable patch.
4. Preserve a rollback path. For risky changes, keep a backup copy or a clearly documented reversible commit/diff before proceeding.
5. Review the complete changed section and nearby dependencies for broken tags, braces, duplicate handlers, stale references, CSS leakage, and unrelated changes.
6. Run available static/syntax checks and focused tests. Test behavior rather than merely checking that the file saved.
7. Verify the new commit and file in GitHub on `game-development`.
8. Provide a downloadable HTML copy when a game HTML file changes, if the environment supports generating and verifying it.
9. Clearly separate tests actually performed from tests the user still needs to do.
10. Record every change in `CHANGELOG.md` and record enough implementation, test, and rollback detail in `DEVELOPMENT_LOG.md` for a future assistant to understand or safely revert it.

## 4. Standalone downloaded HTML is the real target

- The game must work when downloaded and opened directly in a separate Chrome tab, not only in a ChatGPT preview or editor.
- When practical, check the standalone layout and behavior, including responsive/mobile behavior where relevant.
- Do not claim standalone testing unless it was actually performed.
- Never introduce visible source code, CSS, comments, debugging output, or implementation notes into the player-facing game.
- Preserve the existing download workflow.

## 5. Layout and visual preservation

Unless the user explicitly requests a layout change, preserve the existing layout and styling.

Known placement requirements to preserve:
- The main game interface/clicker should remain centered in a standalone desktop Chrome tab where the current layout supports it.
- Gem Station must not force the main interface off-center.
- Hard Reset must remain at the very bottom of the page.
- The Admin panel belongs in the bottom area, not unexpectedly beside Gem Station.
- Bank and Chat placement should remain as currently implemented; do not move them during unrelated work.
- Do not introduce broad CSS overrides or duplicate layout rules to fix an isolated issue.
- Keep the visual design recognizable and avoid unnecessary resizing or restyling.

## 6. Gameplay and save compatibility

Treat all existing systems as protected unless the user names them as the task:
- Clicking, Space-key clicking, and Silent Clicking.
- Auto-clickers, click multipliers, Overclocked, Auto Accelerator, and click statistics.
- Upgrades, multi-purchase controls, and buy-max behavior.
- Rebirth requirements, rebirth rewards, scaling, and gem upgrades.
- Gem Station and its permanent upgrades.
- Bank deposits, withdrawals, conversion, interest, persistence, and offline behavior.
- Local saving, Supabase authentication, cloud saving/loading, cross-device progress, and reset-version handling.
- Username, chat, direct messages, presence, admin/tester permissions, announcements, and admin grants.
- Hard Reset and all reset safeguards.
- Existing account/save compatibility.

Do not change unrelated game balancing, prices, progression, or features while fixing a technical issue.

## 7. Cloud saving and account data

When working on saves:
1. Inspect local save, cloud save, cloud load, login/signup/auth-state flows, reset-version checks, autosave intervals, and every caller that can save or load.
2. Protect against overlapping saves, stale data, and older devices overwriting newer cloud progress.
3. Do not blindly merge local and cloud saves. Define and verify the intended source-of-truth behavior for the specific case.
4. Preserve compatibility with the existing Supabase table/columns and current save shape unless a schema change is explicitly planned and approved.
5. Never expose passwords, service-role keys, secret tokens, or private account data in code, logs, documentation, or chat.
6. Do not claim cross-device sync is proven until the same account has been tested on two devices (or clearly report that this real-world test remains outstanding).
7. Treat offline-progress changes as a separate task unless they are required for the cloud-save fix.

## 8. Safety and regression checks

- Avoid changes that could produce `NaN`, `Infinity`, negative resources, duplicated earnings, duplicated rewards, or lost progress.
- Preserve reset guards and protections against concurrent actions.
- Validate numeric values and missing/older save fields safely.
- Do not run destructive database operations or modify Supabase schema without explicit need and user approval.
- Do not expose private user information.
- If a test fails, stop and investigate rather than layering on unrelated changes.
- If uncertain whether a change is safe, do not silently broaden it.

## 9. GitHub commits, changelog, and rollback records

- Use a specific commit message describing the actual change.
- Keep commits focused; avoid mixing documentation, unrelated fixes, and redesigns in one commit where practical.
- Update `CHANGELOG.md` for each meaningful game or project change.
- Update `DEVELOPMENT_LOG.md` for implementation details, files/functions touched, verification, known limitations, and rollback guidance.
- Never invent historical changes or test results. Mark reconstructed history as a summary when the original complete record is unavailable.
- A changelog entry is not a substitute for a real code review or test.
- Do not delete prior log entries just to make the file shorter.

## 10. Communication and delivery

For each change, tell the user:
- What changed and why, in plain language.
- Which file(s) changed and the commit on `game-development`.
- What was actually tested and the result.
- What remains untested or needs user testing.
- The downloadable HTML link when one was successfully created and verified.
- Any relevant rollback point.

Do not ask the user to manually paste code when the requested workflow is to edit GitHub directly and the available tools permit that edit.

## 11. Current task priority (update when the user changes priorities)

The currently stated first priority is **reliable cross-device cloud saving**: signing into the same account on another device should load the latest progress without losing it or allowing an older save to overwrite a newer one.

Work on this first, narrowly. Do not combine it with an offline-progress overhaul or unrelated features. After cross-device sync is working, the user may prioritize offline progress separately.

## 12. Final pre-commit checklist

- [ ] Correct current file and branch inspected.
- [ ] Requested scope is narrow and explicit.
- [ ] Only necessary lines/features changed.
- [ ] Existing game systems and save compatibility preserved.
- [ ] No visible code/comments/debug text leaked into the game.
- [ ] HTML/CSS/JavaScript syntax and changed flows checked as far as possible.
- [ ] Standalone/download behavior tested if claimed.
- [ ] Rollback path retained.
- [ ] `CHANGELOG.md` and `DEVELOPMENT_LOG.md` updated.
- [ ] Commit and final file verified on `game-development`.
- [ ] User told what remains untested.

**If any rule conflicts with an assumed improvement or convenience, follow these rules and the user's explicit request.**
