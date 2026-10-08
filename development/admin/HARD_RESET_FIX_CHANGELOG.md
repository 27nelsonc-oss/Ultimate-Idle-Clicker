# Hard Reset Fix Changelog

## Date
2026-10-01

## Scope
Fixed the Hard Reset flow on the `game-development` branch after the cloud-save changes made `saveGame()` asynchronous.

## Changes
- Made the Hard Reset handler asynchronous.
- Waits for an in-progress cloud load to finish before resetting, preventing an old cloud save from immediately restoring progress.
- Advances `cloudResetVersion` and stores it locally so the reset participates in the existing cloud-reset synchronization system.
- Resets the full current game state, including `clickOverdriveLevel` and `lastActiveAt`.
- Writes the reset state to localStorage immediately.
- If the player is logged in, saves the reset state to the Supabase cloud save using the existing `game_saves` upsert.
- Temporarily pauses the game loop during the reset so auto-clicks cannot modify the reset state while it is being synchronized.
- If the cloud save cannot be confirmed, the local reset remains in place and the UI reports that the cloud reset needs confirmation.
- No Supabase schema, table, RLS policy, chat, Bank, Admin Grant, Player List, or other gameplay feature was changed.

## Branch
`game-development` only. `main` was not changed.

## Backup
Exact pre-fix HTML:
`development/admin/backups/Ultimate_Idle_Clicker_PRE_HARD_RESET_FIX.html`

## Fix commit
`ef7b809feb34eee0d6795726858af1a9f5a27319`
