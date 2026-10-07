# Cross-Device DM Read Markers

The DM notification read state is now stored in Supabase instead of only in browser localStorage. Opening a DM records the newest incoming message from that sender. When the same account signs in on another device, its stored read markers prevent already-read DMs from appearing as new notifications.

Database table: `public.game_direct_message_reads`, keyed by `user_id, sender_id`, with `last_read_at` and `updated_at`. RLS limits access to the logged-in user's own markers.

No existing DM messages were changed or deleted.