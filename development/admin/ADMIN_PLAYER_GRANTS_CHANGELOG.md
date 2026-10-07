# Admin Player Grant Controls

## Change
Added owner-only Admin Panel controls for:
- adding Banked Clicks to the current admin's own account;
- adding selected resources to another player's cloud save by email.

## Security
- The other-player account controls are visible only when the signed-in account is the owner account.
- The server-side Supabase Edge Function independently enforces the owner email, so hiding the UI is not the security boundary.
- Other admin accounts cannot use the target-player grant endpoint.
- The browser never receives the Supabase service-role key.

## Target resources
The owner can add:
- Clicks
- Banked Clicks
- Gems
- Auto Clickers
- Click Upgrades
- Rebirths
- More Gems/Rebirth Levels
- Overclock Levels
- Auto Accelerator Levels
- Click Overdrive Levels
- Gem Station Levels
- Upgrade Discount Levels

## Important behavior
The target-player tool edits the saved cloud state. If the target player is actively playing an older local state, their next cloud save could overwrite the server-side change. The intended safe workflow is to have the target refresh/reload after a grant.

## Rollback
See `ADMIN_PLAYER_GRANTS_ROLLBACK.md` and the exact pre-change backup in `development/admin/backups/`.
