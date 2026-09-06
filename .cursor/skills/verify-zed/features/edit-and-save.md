# Edit and save

Editing types into the active buffer; save writes the buffer to disk so a second view matches what the user typed.

## Sub-features

- `edit-type` inserts characters into the focused editor.
- `edit-save` persists via `Ctrl+S` / Save.
- `edit-verify-disk` re-reads the file from the filesystem.

## How to get to it (user POV)

- Click or open a file tab, type, then `Ctrl+S` or File → Save.
- Create a new file with `Ctrl+N`, type, Save As (Save As is a heavier path; prefer editing `hello.txt` for agents).

## Driving it with control-zed

Preconditions:

- Instance on the fixture project; `hello.txt` open (use file-finder recipe first).
- `doctor` PASS.

- **Baseline screenshot.** `control-zed screenshot --id demo --out .../artifacts/demo/edit-before.png`.
- **Edit.** Run `control-zed type --id demo --text ' VERIFY'`.
- **Save.** Run `control-zed key --id demo ctrl+s`.
- **Disk check.** `grep -F 'VERIFY' .cursor/skills/verify-zed/fixtures/sample-project/hello.txt` exits 0.
- **After screenshot.** `control-zed screenshot --id demo --out .../artifacts/demo/edit-after.png`.
- **Restore fixture.** Rewrite `hello.txt` to its original `hello from verify-zed` contents after proof (keep artifacts).

## Gotchas

- Typing without an editor focused can hit the project panel or UI chrome — open `hello.txt` first.
- Autosave settings in a non-isolated profile can surprise you; this harness always uses a disposable data dir.
- Proof is the on-disk file, not only the buffer screenshot.
