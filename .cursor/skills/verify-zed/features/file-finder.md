# File finder

File finder fuzzy-searches project paths and opens the selected file in the editor.

## Sub-features

- `finder-open` shows the file finder overlay.
- `finder-query` filters paths by substring.
- `finder-open-file` opens the highlighted match into a tab.

## How to get to it (user POV)

- Press `Ctrl+P` (Linux default; also `Ctrl+E` in some contexts).
- Use the command palette action that toggles the file finder.

## Driving it with control-zed

Preconditions:

- Instance on `.cursor/skills/verify-zed/fixtures/sample-project` with `doctor` PASS.

- **Open finder.** Run `control-zed key --id demo ctrl+p`. Finder overlay appears.
- **Query.** Run `control-zed type --id demo --text 'hello'`. Match list includes `hello.txt`.
- **Open.** Run `control-zed key --id demo Return`.
- **Confirm.** Run `control-zed wait-title --id demo --pattern hello.txt` (or screenshot showing `hello.txt` tab/buffer).
- **Proof.** `finder-open.png` + `hello-open.png` (or title containing `hello.txt`).

## Gotchas

- `Ctrl+P` in other contexts (e.g. some panels) may bind differently; start from the editor workspace.
- Query is fuzzy; short queries may show many matches — prefer unique fixture names (`hello.txt`).
