# Zed verification map

Maintained source for verifying user-facing Zed desktop behavior. Read this index, then the matching feature file, before driving the app.

## Baseline preconditions

- Build: `cargo build -p zed` from the repo root (or set `ZED_BIN` to an existing binary).
- Display: X11 available (`DISPLAY=:1` on Cloud agent VMs).
- Launch only through `.cursor/skills/verify-zed/scripts/control-zed launch --id <id>`.
- Require `control-zed doctor --id <id>` PASS before sending keys.
- Default fixture: `.cursor/skills/verify-zed/fixtures/sample-project` (`hello.txt`, `notes.md`).
- Never drive a window that this run did not start. Never use the developer's real Zed config/data dirs.

## Driving conventions

- Start every recipe from a freshly launched instance unless the feature says otherwise.
- Prefer documented Linux keybindings (`assets/keymaps/default-linux.json`) over mouse coordinates.
- Treat harness commands as literal.
- Restore or discard fixture edits after mutation proofs; keep screenshot/log artifacts.
- Put evidence in `.cursor/skills/verify-zed/artifacts/<id>/`.

## Proof and skip reporting

- Capture the user action and the resulting state (title change, screenshot, file on disk).
- Mutation proof includes a read-only second look at the saved file contents.
- Record feature id + entry point with every artifact set.
- If a path is unreachable, report the attempted command and unmet precondition — do not mark it verified via a different path.

## Feature entry contract

Each feature file: H1 title, one paragraph of user-visible behavior, then exactly these H2s in order:

1. `Sub-features`
2. `How to get to it (user POV)`
3. `Driving it with control-zed`
4. `Gotchas`

## Features

- [Open a project](./open-project.md) — launch Zed on a folder and confirm the workspace shows fixture files.
- [Command palette](./command-palette.md) — open the palette, run a command, observe the result.
- [File finder](./file-finder.md) — fuzzy-open a file from the project.
- [Edit and save](./edit-and-save.md) — type into a buffer and save; confirm disk contents.
- [Project panel](./project-panel.md) — focus the project panel and reveal fixture entries.
