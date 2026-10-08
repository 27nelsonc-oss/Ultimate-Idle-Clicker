# Global Announcements — Rollback

## HTML rollback
Restore the exact pre-feature HTML from:

`development/admin/backups/Ultimate_Idle_Clicker_PRE_GLOBAL_ANNOUNCEMENTS.html`

## Database rollback
If the feature should be completely removed, run:

```sql
alter publication supabase_realtime
    drop table public.game_global_announcement;

drop table if exists public.game_global_announcement;
```

This removes the announcement table, its RLS policies, and its stored announcement.

## Git
Feature commit:
`73d285077668bb88d910c626d29b53803a2402f5`

Backup commit:
`067cb128a4da071101da419d1123ce10a07dcd91`
