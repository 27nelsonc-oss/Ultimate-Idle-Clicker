# Ultimate Idle Clicker

This repository contains the Ultimate Idle Clicker game and its development history.

## Before editing the game

1. Read [DEVELOPMENT_RULES.md](DEVELOPMENT_RULES.md) — the master list of editing rules and absolute laws.
2. Check [CHANGELOG.md](CHANGELOG.md) — user-visible changes and current priorities.
3. Check [DEVELOPMENT_LOG.md](DEVELOPMENT_LOG.md) — technical context, verification notes, and rollback records.
4. Fetch the current HTML from `game-development` before making any change.

## Branch safety

- `game-development` is the working branch for changes.
- `main` is protected by project rules and must not be modified or merged into without explicit authorization.
- The downloaded standalone HTML remains an important test target.

## Current first priority

Fix cross-device cloud saving so the same account reliably loads the latest progress across devices. Offline progress is a separate follow-up task. See the active-task notes in [DEVELOPMENT_LOG.md](DEVELOPMENT_LOG.md).
