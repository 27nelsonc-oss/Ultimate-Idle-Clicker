-- Player List feature migration
create extension if not exists pgcrypto with schema extensions;
alter table public.game_profiles add column if not exists email_lookup_hash text;
create index if not exists game_profiles_email_lookup_hash_idx on public.game_profiles (email_lookup_hash);
create schema if not exists private;

create or replace function private.sync_game_profile_email_lookup_hash()
returns trigger language plpgsql security definer set search_path = ''
as $$
begin
  if tg_table_schema = 'auth' and tg_table_name = 'users' then
    update public.game_profiles
      set email_lookup_hash = case when new.email is null then null else encode(extensions.digest(lower(trim(new.email)), 'sha256'), 'hex') end,
          updated_at = now()
    where user_id = new.id;
  elsif tg_table_schema = 'public' and tg_table_name = 'game_profiles' then
    update public.game_profiles
      set email_lookup_hash = case
        when (select u.email from auth.users u where u.id = new.user_id) is null then null
        else encode(extensions.digest(lower(trim((select u.email from auth.users u where u.id = new.user_id))), 'sha256'), 'hex')
      end
    where user_id = new.user_id;
  end if;
  return new;
end;
$$;

drop trigger if exists sync_game_profile_email_hash_from_auth on auth.users;
create trigger sync_game_profile_email_hash_from_auth after insert or update of email on auth.users
for each row execute function private.sync_game_profile_email_lookup_hash();

drop trigger if exists sync_game_profile_email_hash_from_profile on public.game_profiles;
create trigger sync_game_profile_email_hash_from_profile after insert or update of user_id on public.game_profiles
for each row execute function private.sync_game_profile_email_lookup_hash();

update public.game_profiles p
set email_lookup_hash = encode(extensions.digest(lower(trim(u.email)), 'sha256'), 'hex')
from auth.users u
where u.id = p.user_id
  and u.email is not null
  and p.email_lookup_hash is distinct from encode(extensions.digest(lower(trim(u.email)), 'sha256'), 'hex');

revoke execute on function private.sync_game_profile_email_lookup_hash() from public, anon, authenticated;

drop policy if exists "authenticated can read player list presence" on realtime.messages;
drop policy if exists "authenticated can track player list presence" on realtime.messages;
create policy "authenticated can read player list presence" on realtime.messages
for select to authenticated
using (realtime.topic() = 'ultimate-idle-clicker-player-presence' and realtime.messages.extension = 'presence');
create policy "authenticated can track player list presence" on realtime.messages
for insert to authenticated
with check (realtime.topic() = 'ultimate-idle-clicker-player-presence' and realtime.messages.extension = 'presence');
