# Global Announcements — Changelog

## Added
- Added an owner-only **Global Announcement** section to the Admin Panel.
- Owner can publish one announcement for all players.
- Owner can clear the current announcement.
- Announcement text is limited to 500 characters.
- Announcement is displayed near the top of the main game panel.
- All players receive announcement updates through Supabase Realtime.
- Announcement authorization is enforced by Supabase Row Level Security, not only by the hidden UI.
- Signed-out players can read a currently published announcement; only the owner can create/update/delete it.

## Database
- Added `public.game_global_announcement`.
- Realtime publication includes the announcement table.
- Owner authorization is tied to the existing Owner account email already used by the game.

## Preservation
- Existing game mechanics and existing Admin tools were not intentionally changed.
- Hard Reset remains at the bottom.
- Admin Panel remains at the bottom.
- `main` branch was not changed.

## Backup
- Exact pre-change HTML backup:
  `development/admin/backups/Ultimate_Idle_Clicker_PRE_GLOBAL_ANNOUNCEMENTS.html`
- Backup commit: `067cb128a4da071101da419d1123ce10a07dcd91`
- Feature commit: `73d285077668bb88d910c626d29b53803a2402f5`
