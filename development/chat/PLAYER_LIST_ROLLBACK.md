# Player List Rollback

Restore the pre-player-list HTML backup, then run `PLAYER_LIST_ROLLBACK.sql`.

The rollback removes only the email lookup hash/index, its sync triggers/function, and the two Player List Presence policies.

It does not drop or modify chat messages, DMs, saves, Bank data, accounts, or usernames.
