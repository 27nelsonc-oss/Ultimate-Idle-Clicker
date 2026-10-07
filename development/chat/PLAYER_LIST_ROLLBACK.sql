drop policy if exists "authenticated can read player list presence" on realtime.messages;
drop policy if exists "authenticated can track player list presence" on realtime.messages;
drop trigger if exists sync_game_profile_email_hash_from_auth on auth.users;
drop trigger if exists sync_game_profile_email_hash_from_profile on public.game_profiles;
drop function if exists private.sync_game_profile_email_lookup_hash();
drop index if exists public.game_profiles_email_lookup_hash_idx;
alter table public.game_profiles drop column if exists email_lookup_hash;
