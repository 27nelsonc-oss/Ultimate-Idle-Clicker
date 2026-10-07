# Player List Feature Change Log

## What changed
- Added a Player List panel directly under Gem Station on the desktop layout.
- Added username search and exact account-email lookup.
- Email lookup uses a SHA-256 lookup hash stored in `game_profiles`; the game does not display other players' email addresses.
- Added green Online and gray Offline indicators.
- Added Supabase Realtime Presence so online status updates when players join or leave.
- Clicking a player name opens the existing Direct Message system.
- Added mobile ordering so Player List follows Gem Station.
- Shifted Hard Reset and Admin Panel down one desktop grid row so they remain below the main content.

## Supabase changes
- Added `game_profiles.email_lookup_hash` and an index.
- Added private trigger synchronization for email lookup hashes.
- Added authenticated Realtime Presence policies for `ultimate-idle-clicker-player-presence`.
- Existing chat, DM, save, Bank, Rebirth, and username systems were not otherwise changed.

## Privacy
The Player List does not show another player's email. An entered email is normalized and hashed in the browser, then matched against the stored lookup hash.

## Rollback
See `development/chat/PLAYER_LIST_ROLLBACK.md` and `development/chat/PLAYER_LIST_ROLLBACK.sql`.
