# Admin Player Grant Queue Change

## Problem
The previous Admin Panel player-grant feature directly edited another player's current cloud save. If that player was actively playing, their older local state could autosave afterward and overwrite the administrator's change.

## Fix
The owner-only Edge Function now queues grants in `public.game_admin_player_grants` instead of directly replacing the target's save.

When the target player is logged in:
1. The game claims pending grants for that account.
2. The grant is applied to the player's current local game state.
3. The game saves that current state to cloud.
4. The grant is deleted only after the cloud save succeeds.
5. If saving fails, the grant is released so it can be retried.

## Resources
The queue supports clicks, banked clicks, gems, auto clickers, click upgrades, rebirths, and the existing upgrade-level resources.

## Security
- Only the owner account can create grants.
- Players can only claim grants targeted to their own account.
- Claim/complete/release functions require an authenticated user.
- The service role is used only inside the owner-protected Edge Function.

## GitHub
Game change commit: `b1acb21f6e66f4aee3ffefdc751a75c9dd2b2e41`

## Supabase
Edge Function `admin-modify-player-save` version 2.
Migration: `add_admin_player_grant_queue`.

## Rollback
See `ADMIN_PLAYER_GRANTS_QUEUE_ROLLBACK.md` and `ADMIN_PLAYER_GRANTS_QUEUE_ROLLBACK.sql`.
