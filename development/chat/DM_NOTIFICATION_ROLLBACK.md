# DM Notification Rollback

This change added only the client-side unread DM notification indicator. It made NO Supabase changes.

To roll back the notification feature while keeping Direct Messaging:
1. Restore:
   development/chat/backups/Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME_PRE_DM_NOTIFICATION.html
2. Replace the current game file with that backup on the game-development branch.

Pre-notification game content SHA:
c9474062ec34a5d8595ae3ff2140f62b9617afcc

Notification commit:
b0e6864062775ce9413be2f22fee7fd8dad485ea

DO NOT run development/chat/DM_ROLLBACK.sql for this rollback. That SQL removes the entire DM database table and is unrelated to the notification-only change.
