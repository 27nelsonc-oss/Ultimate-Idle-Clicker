-- Player Online Heartbeat migration
alter table public.game_profiles add column if not exists last_seen_at timestamptz;

create index if not exists game_profiles_last_seen_at_idx
    on public.game_profiles (last_seen_at desc);
