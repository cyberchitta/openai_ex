@AGENTS.md

The maintainer's working notes, when present, are in `_notes/`. It is a gitignored symlink, so `Grep` and `Glob` silently find nothing there; search it with `rg <pattern> _notes/`. `_notes/worklist.md` is the open-work list.

Code follows the global `code-style` and `elixir-style` skills; load them before writing code. They are not in `AGENTS.md`, which outside contributors read without those skills. The checks run in the Livebook container (see `AGENTS.md`).
