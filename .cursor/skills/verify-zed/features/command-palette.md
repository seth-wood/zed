# Command palette

The command palette lets the user search and run editor actions by name without leaving the keyboard.

## Sub-features

- `palette-open` shows the palette UI via shortcut.
- `palette-filter` narrows actions by typed query.
- `palette-run` executes the selected action (example: toggle left dock / project panel related commands).

## How to get to it (user POV)

- Press `Ctrl+Shift+P` (Linux default).
- Press `F1`.
- Use the menu entry that opens the command palette (when menus are available).

## Driving it with control-zed

Preconditions:

- Instance launched and `doctor` PASS (see open-project).
- Fixture project loaded.

- **Open palette.** Run `control-zed key --id demo ctrl+shift+p`. Palette overlay appears (screenshot).
- **Filter.** Run `control-zed type --id demo --text 'toggle left dock'`. Matching actions list updates.
- **Run.** Run `control-zed key --id demo Return`. Palette closes; left dock visibility changes.
- **Proof.** Screenshots: `palette-open.png` (overlay visible), `palette-after.png` (dock state changed). Optionally toggle again to restore.

## Gotchas

- Typing while the palette is closed inserts into the editor buffer — always open the palette first.
- Action display names can differ slightly from action ids; filter by the user-visible label.
- If focus was stolen by another window, `doctor` still PASSes but keys go elsewhere — re-run focus via any harness command (they activate the window).
