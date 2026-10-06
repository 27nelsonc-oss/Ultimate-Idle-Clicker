# DM Unread Notification v2

- Base file SHA: c9474062ec34a5d8595ae3ff2140f62b9617afcc
- Added red unread-count badge beside Chat title.
- Uses a per-user localStorage read marker.
- Existing historical DMs are not marked unread the first time the feature sees that account.
- Login/session restoration refreshes unread state.
- Existing Supabase Realtime DM INSERT listener refreshes unread state for new incoming DMs.
- Opening a DM marks incoming messages in that conversation as read.
- Returning to Global Chat refreshes unread state.
- No Supabase schema, RLS, indexes, or Realtime publication changes were made.
- A real two-account gameplay test is still required.

Rollback: restore the exact backup at development/chat/backups/Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME_PRE_DM_NOTIFICATION_V2.html
