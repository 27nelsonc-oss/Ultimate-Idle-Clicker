-- Chat Reset / Retention rollback

select cron.unschedule('ultimate-idle-clicker-chat-cleanup');

drop index if exists public.game_chat_messages_created_at_idx;
