-- Remove only the player online heartbeat RPC.
drop function if exists public.touch_player_presence();