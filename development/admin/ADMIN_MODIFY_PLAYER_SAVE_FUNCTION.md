# admin-modify-player-save

Supabase Edge Function deployed for the owner-only Admin Panel player grant feature.

Security boundary:
- Requires a valid Supabase user session.
- Requires caller email to be the owner account.
- Uses the server-side service role only inside the Edge Function.
- Target account is selected by email.
- Only additive resource changes are accepted.

This function is intentionally separate from `admin-reset-save`.
