# Admin Player Grant Queue Rollback

## Game rollback
The exact pre-queue game version is the game file at GitHub commit `28a6cf69e75ae758d96e4c0744cff430338b4ef4`.

The previous direct-write Edge Function was version 1 of `admin-modify-player-save`.

## Supabase rollback
Run `ADMIN_PLAYER_GRANTS_QUEUE_ROLLBACK.sql` to remove the queue functions/table after confirming there are no pending grants that should be delivered.

Then redeploy the previous version of `admin-modify-player-save` if the old behavior is intentionally required.

## Important
Do not delete the queue table while it contains grants that players still need to receive.
