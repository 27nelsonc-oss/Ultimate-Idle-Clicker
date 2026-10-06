# Direct Messaging Change Log

## Change set
**Feature:** Direct messaging from the existing public Chat panel  
**Git branch:** game-development  
**Date:** 2026-10-06  
**Database migration:** `add_game_direct_messages`

## Safety / rollback
A complete pre-DM copy of the game file is stored at:

`development/chat/backups/Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME_PRE_DM.html`

The exact database rollback SQL is stored at:

`development/chat/DM_ROLLBACK.sql`

Git history also contains the HTML change as its own commit.

## What changed in the HTML file

1. Added a small **"← Back to Global Chat"** button to the existing Chat panel. It is hidden during Global Chat and shown during a DM.
2. The existing **Chat** heading can temporarily show **"💬 DM: <username>"** while a private conversation is open.
3. Global chat usernames are now clickable when they belong to another player.
4. Clicking another player's username opens a DM with that player in the same existing chat box.
5. Added a **Global Chat → DM** mode switch without creating a second chat panel or moving the chat panel.
6. Added DM message loading using the new Supabase DM table.
7. Added DM sending using the same existing message box and Send button.
8. Added a small status message if the DM cannot load or send.
9. Added Realtime handling for the new DM table so an open DM can refresh when a new message arrives.
10. Existing global chat loading, global chat sending, username system, rank display, chat rate limit, and existing Supabase cloud-save systems were left in place.
11. No game mechanics, click calculations, upgrades, Bank logic, Rebirth logic, Admin controls, Hard Reset behavior, or layout positioning were intentionally changed.

## Supabase changes

### New table
`public.game_direct_messages`

Columns:
- `id` bigint identity primary key
- `sender_id` uuid → `auth.users.id`
- `recipient_id` uuid → `auth.users.id`
- `sender_username` text
- `message` text, limited to 1–300 characters
- `created_at` timestamptz

### Security
- RLS enabled.
- `anon` has no access.
- `authenticated` has only SELECT and INSERT table privileges.
- SELECT policy allows a user to see only rows where they are the sender or recipient.
- INSERT policy requires the sender ID to equal the logged-in user and the sender username to match that user's `game_profiles` username.
- No UPDATE or DELETE policy was added for players.
- Two indexes were added for sender/recipient conversation lookups.

### Realtime
The new table was added to the existing `supabase_realtime` publication.

### Existing Supabase objects intentionally NOT changed
- `game_chat_messages`
- `game_profiles`
- `game_saves`
- `game_admins`
- `admin_access_requests`
- Existing policies on those tables
- Existing Edge Functions

## Revert procedure

### If only the HTML DM feature is the problem
Restore the pre-DM backup file or revert the HTML commit on `game-development`.

### If the Supabase DM table also needs to be removed
Run the contents of:

`development/chat/DM_ROLLBACK.sql`

That rollback drops only `game_direct_messages` and its Realtime publication entry.

## Important
The DM database change is separate from the HTML change. Reverting the GitHub HTML commit does **not** automatically undo the Supabase database table. Use the rollback SQL if the database change also needs to be undone.
