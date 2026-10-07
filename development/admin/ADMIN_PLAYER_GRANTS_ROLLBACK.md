# Rollback: Admin Player Grant Controls

1. Restore the game HTML from:
   `development/admin/backups/Ultimate_Idle_Clicker_PRE_ADMIN_PLAYER_GRANTS.html`
2. Redeploy/disable the Supabase Edge Function named:
   `admin-modify-player-save`
   If deletion is unavailable, redeploy a version that always returns HTTP 403 and does not modify saves.
3. No database tables, RLS policies, or existing game-save rows were intentionally changed by this feature.
4. The existing `admin-reset-save` function is separate and should not be removed.
