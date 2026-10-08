create table if not exists public.game_global_announcement (
    id integer primary key default 1 check (id = 1),
    message text,
    updated_at timestamptz not null default now(),
    updated_by uuid references auth.users(id) on delete set null,
    constraint game_global_announcement_message_length
        check (message is null or char_length(message) between 1 and 500)
);

alter table public.game_global_announcement enable row level security;

revoke all on public.game_global_announcement from anon, authenticated;
grant select on public.game_global_announcement to anon, authenticated;
grant insert, update, delete on public.game_global_announcement to authenticated;

drop policy if exists "Global announcements are publicly readable" on public.game_global_announcement;
create policy "Global announcements are publicly readable"
on public.game_global_announcement
for select
to anon, authenticated
using (
    (message is not null and char_length(trim(message)) > 0)
    or (select auth.jwt()->>'email') = '27nelsonc@student.harrisburg.k12.or.us'
);

drop policy if exists "Owner can create global announcement" on public.game_global_announcement;
create policy "Owner can create global announcement"
on public.game_global_announcement
for insert
to authenticated
with check (
    (select auth.jwt()->>'email') = '27nelsonc@student.harrisburg.k12.or.us'
);

drop policy if exists "Owner can update global announcement" on public.game_global_announcement;
create policy "Owner can update global announcement"
on public.game_global_announcement
for update
to authenticated
using (
    (select auth.jwt()->>'email') = '27nelsonc@student.harrisburg.k12.or.us'
)
with check (
    (select auth.jwt()->>'email') = '27nelsonc@student.harrisburg.k12.or.us'
);

drop policy if exists "Owner can delete global announcement" on public.game_global_announcement;
create policy "Owner can delete global announcement"
on public.game_global_announcement
for delete
to authenticated
using (
    (select auth.jwt()->>'email') = '27nelsonc@student.harrisburg.k12.or.us'
);

alter publication supabase_realtime
    add table public.game_global_announcement;
