-- ROLLBACK for add_game_direct_messages
-- Run this only if you want to completely remove the DM database feature.
-- This drops ONLY the new DM table and its indexes/policies/publication entry.
-- It does NOT modify game_chat_messages, game_profiles, game_saves, or any existing chat data.

begin;

alter publication supabase_realtime drop table if exists public.game_direct_messages;

drop table if exists public.game_direct_messages;

commit;
