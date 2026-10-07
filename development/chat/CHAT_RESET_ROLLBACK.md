# Chat Reset / Retention Rollback

Restore the pre-change game backup:
`development/chat/backups/Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME_PRE_CHAT_RESET.html`

Then run `CHAT_RESET_ROLLBACK.sql` in Supabase.

This rollback removes only the scheduled cleanup job and the cleanup index. It does not drop the chat/DM tables, delete messages, or touch usernames, profiles, saves, Admin, Bank, or Realtime.
