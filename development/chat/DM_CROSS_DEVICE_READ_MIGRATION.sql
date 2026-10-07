create table public.game_direct_message_reads (
  user_id uuid not null references auth.users(id) on delete cascade,
  sender_id uuid not null references auth.users(id) on delete cascade,
  last_read_at timestamptz not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, sender_id)
);

alter table public.game_direct_message_reads enable row level security;

create policy "Users can read their own DM read markers"
on public.game_direct_message_reads for select to authenticated
using (auth.uid() = user_id);

create policy "Users can insert their own DM read markers"
on public.game_direct_message_reads for insert to authenticated
with check (auth.uid() = user_id);

create policy "Users can update their own DM read markers"
on public.game_direct_message_reads for update to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create index game_direct_message_reads_sender_idx
on public.game_direct_message_reads (sender_id);

grant select, insert, update on public.game_direct_message_reads to authenticated;