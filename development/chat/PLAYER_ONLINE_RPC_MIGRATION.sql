-- Player online heartbeat RPC
create or replace function public.touch_player_presence()
returns timestamptz
language plpgsql
security definer
set search_path = public
as $$
declare
  touched_at timestamptz := now();
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;
  update public.game_profiles
  set last_seen_at = touched_at,
      updated_at = touched_at
  where user_id = auth.uid();
  if not found then
    raise exception 'Player profile not found';
  end if;
  return touched_at;
end;
$$;

revoke all on function public.touch_player_presence() from public, anon;
grant execute on function public.touch_player_presence() to authenticated;
