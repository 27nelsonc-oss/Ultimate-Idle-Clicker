# Player Online Status Fix

## Problem
The Player List was using Supabase Realtime Presence as the source of truth for online status. In testing, this could show only a small subset of online players and could flicker players between Online and Offline during presence sync events.

## Fix
The Player List now uses a lightweight heartbeat stored on each player's existing `game_profiles` row:
- `last_seen_at` records the player's most recent heartbeat.
- The game updates the logged-in player's heartbeat every 10 seconds.
- A player is considered Online when their heartbeat is less than 30 seconds old.
- The Player List refreshes every 10 seconds so other players' status updates appear without requiring Realtime Presence events.
- Existing Realtime Presence code remains in place, but it is no longer used as the source of online/offline truth.

## Supabase changes
- Added `public.game_profiles.last_seen_at timestamptz`.
- Added `game_profiles_last_seen_at_idx`.
- No existing accounts, usernames, chat, DMs, saves, Bank, Admin, or Rebirth data was changed.
- Existing `game_profiles` authenticated SELECT and own-row UPDATE policies allow this heartbeat update.

## Online timing
- Heartbeat interval: 10 seconds.
- Offline threshold: 30 seconds without a heartbeat.
- This avoids the one-second Online/Offline flicker caused by Realtime Presence sync.

## Rollback
See `PLAYER_HEARTBEAT_ROLLBACK.md`.
