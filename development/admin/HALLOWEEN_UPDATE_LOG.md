# Halloween Branch Update Log

## 2026-10-13 — The Plauge title
- Added the one-person-only title **The Plauge** to the titles panel.
- Unlock phrase: type the exact message `God wills it` in global chat while signed in.
- Hint displayed in the title panel: **Deus lo vult**.
- Added a light-to-dark green gradient for the title in the collection and chat badge.
- Added Supabase claim/status functions and expanded the title ID constraints. The database claim row is unique per title, so only one account can win even if multiple players try at nearly the same time.
- Validation: HTML inline JavaScript syntax checked; Supabase title constraints and RPC execute permissions verified. The live browser/chat claim flow has not been tested end-to-end.
