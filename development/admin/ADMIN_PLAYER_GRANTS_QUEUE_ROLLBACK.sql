-- Rollback for add_admin_player_grant_queue
-- WARNING: dropping this table removes pending admin grants.

revoke all on public.game_admin_player_grants from anon, authenticated;

drop function if exists public.claim_game_admin_player_grants(integer);
drop function if exists public.complete_game_admin_player_grants(bigint[]);
drop function if exists public.release_game_admin_player_grants(bigint[]);

drop table if exists public.game_admin_player_grants;