# Chat Reset / Retention Change

Date: 2026-10-07

## Game behavior
- Global Chat only displays messages from the current 12-hour local cycle.
- Global Chat cycles begin at 12:00 AM and 12:00 PM.
- Direct Messages only display messages from the current 48-hour local cycle.
- Direct Message cycles are anchored to 12:00 AM and run in 48-hour blocks.
- The page schedules a refresh at the next reset boundary so an open chat updates automatically.

## Database retention
- Global Chat and Direct Message rows older than 48 hours are permanently deleted.
- Supabase Cron runs the cleanup daily at 00:05 UTC; the 48-hour age rule determines what is actually deleted.
- Added an index on `game_chat_messages.created_at` to support retention cleanup.

## Supabase changes
- Enabled/used Supabase Cron (pg_cron).
- Added cron job: `ultimate-idle-clicker-chat-cleanup`.
- No changes to user accounts, usernames, ranks, saves, Bank, Admin, Rebirth, or other game systems.
- No changes to chat/DM RLS policies.

## Rollback
See `CHAT_RESET_ROLLBACK.md`.
