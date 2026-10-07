# Player Online Heartbeat Rollback

## Game rollback
Restore:
`development/chat/backups/Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME_PRE_PLAYER_HEARTBEAT.html`

This restores the exact HTML from before the heartbeat change.

## Supabase rollback
Run:

```sql
drop index if exists public.game_profiles_last_seen_at_idx;
alter table public.game_profiles drop column if exists last_seen_at;
```

This removes only the heartbeat column and its index. It does not drop or modify the player accounts, usernames, chat, DMs, saves, Bank, Admin, or existing Realtime Presence policies.

Do not run the older Player List rollback unless you intend to remove the entire Player List feature.
