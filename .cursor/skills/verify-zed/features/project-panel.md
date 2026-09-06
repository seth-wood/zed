# Project panel

The project panel lists worktree files and folders so the user can navigate the project without the file finder.

## Sub-features

- `panel-focus` moves focus to the project panel (`Ctrl+Shift+E`).
- `panel-toggle-dock` shows or hides the left dock (`Ctrl+B`).
- `panel-entries` shows fixture filenames in the panel tree.

## How to get to it (user POV)

- Press `Ctrl+Shift+E` to focus the project panel.
- Press `Ctrl+B` to toggle the left dock.
- Click the project panel icon in the left dock.

## Driving it with control-zed

Preconditions:

- Instance on the fixture project; `doctor` PASS.

- **Ensure dock visible.** Run `control-zed key --id demo ctrl+b` once if the left dock is hidden (screenshot to confirm). If unsure, toggle, screenshot, toggle back to a state where the panel is visible.
- **Focus panel.** Run `control-zed key --id demo ctrl+shift+e`.
- **Screenshot.** `control-zed screenshot --id demo --out .../artifacts/demo/project-panel.png`. Image shows `hello.txt` and/or `notes.md` in the tree.
- **Proof.** Screenshot with fixture entry names visible.

## Gotchas

- Toggling `Ctrl+B` blindly can hide the panel you meant to prove — capture a screenshot after each toggle.
- Panel focus does not by itself open a file; pair with Enter/click or use file-finder for open proofs.
