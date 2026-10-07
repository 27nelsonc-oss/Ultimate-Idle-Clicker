-- Chat Reset / Retention migration

create extension if not exists pg_cron;

create index if not exists game_chat_messages_created_at_idx
    on public.game_chat_messages (created_at);

select cron.unschedule('ultimate-idle-clicker-chat-cleanup')
where exists (
    select 1 from cron.job where jobname = 'ultimate-idle-clicker-chat-cleanup'
);

select cron.schedule(
    'ultimate-idle-clicker-chat-cleanup',
    '5 0 * * *',
    $job$
      delete from public.game_chat_messages
      where created_at < now() - interval '48 hours';

      delete from public.game_direct_messages
      where created_at < now() - interval '48 hours';
    $job$
);
