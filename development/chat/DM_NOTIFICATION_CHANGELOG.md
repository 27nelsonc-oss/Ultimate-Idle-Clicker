# DM Notification Change Record

## Purpose
Add a small unread Direct Message indicator so a recipient can see that they have new DMs without opening a separate inbox.

## Scope
- Repository: 27nelsonc-oss/Ultimate-Idle-Clicker
- Branch: game-development
- Current game file: Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html
- Change commit: b0e6864062775ce9413be2f22fee7fd8dad485ea
- Pre-change game content SHA: c9474062ec34a5d8595ae3ff2140f62b9617afcc
- Pre-change backup:
  development/chat/backups/Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME_PRE_DM_NOTIFICATION.html
- Backup commit: c393da4e6766149514a2dd72c2b2b8c454075aaf

## HTML/JavaScript changes
1. Added a small red unread-count badge next to the existing Chat heading.
2. Added client-side DM unread state using localStorage, keyed by the logged-in Supabase user ID.
3. Added a Supabase count query against game_direct_messages for messages where the current user is recipient and whose created_at is newer than the locally stored last-read timestamp.
4. When a DM conversation is opened, incoming messages displayed in that conversation are marked read using the newest displayed incoming message timestamp.
5. When a new DM Realtime INSERT arrives:
   - if it belongs to the currently open DM, the conversation reloads and the displayed incoming messages are marked read;
   - otherwise, the unread count is refreshed.
6. Returning to Global Chat refreshes the unread count.
7. Existing DM sending/loading behavior remains in place.
8. No separate inbox was added.

## Supabase changes
NONE.

The existing public.game_direct_messages table, RLS policies, indexes, and Realtime publication were NOT modified by this change.
The existing game_chat_messages, game_profiles, game_saves, game_admins, and admin_access_requests objects were NOT modified.

## Rollback
To remove only this notification feature from the game file, restore the pre-change backup above, or restore the game file to pre-change content SHA c9474062ec34a5d8595ae3ff2140f62b9617afcc.

No Supabase rollback is required for this notification change because no Supabase schema, policy, index, or publication changes were made.

## Important
This rollback removes the notification code but does NOT remove the Direct Messaging feature itself. The separate DM rollback file remains:
development/chat/DM_ROLLBACK.sql
That file should only be used if the entire DM database feature is intentionally being removed.
