# Hard Reset Fix Rollback

## Purpose
Rollback record for the Hard Reset synchronization fix.

## Exact pre-fix backup
`development/admin/backups/Ultimate_Idle_Clicker_PRE_HARD_RESET_FIX.html`

## Pre-fix HTML blob
`e2ec472c869371737bd9e26790adab201a9fd699`

## Fix commit
`ef7b809feb34eee0d6795726858af1a9f5a27319`

## Rollback procedure
If the Hard Reset fix causes a regression, restore the exact backup HTML over:

`Ultimate_Idle_Clicker_Version_1.5_BANK_MULTI_PURCHASES_REBIRTH_BOTH_CLICK_FIXED2_CHAT_USERNAME.html`

Do not roll back unrelated Supabase migrations or features; this fix changed only the HTML Hard Reset/cloud synchronization logic.
