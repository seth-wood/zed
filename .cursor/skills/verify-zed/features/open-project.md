# Open a project

Opening a project loads a folder into a Zed workspace so the user can browse and edit its files.

## Sub-features

- `open-folder` launches Zed with a directory path and shows a workspace window.
- `open-file-arg` launches Zed with a file path and focuses that buffer.
- `isolated-profile` keeps config/db under the disposable `--user-data-dir`.

## How to get to it (user POV)

- From a terminal: run Zed with a folder path (`zed .` / `target/debug/zed /path/to/project`).
- From the welcome/empty state: Open Folder (not covered by the default harness recipe; use path launch).
- From another Zed window: File → Open (GUI menu; prefer path launch for agents).

## Driving it with control-zed

Preconditions:

- `cargo build -p zed` completed (or `ZED_BIN` set).
- `DISPLAY` points at a live X11 server.
- No existing instance with the same `--id`.

- **Launch on fixture.** Run `.cursor/skills/verify-zed/scripts/control-zed launch --id open1 --project .cursor/skills/verify-zed/fixtures/sample-project`. Output includes `ZED_VERIFY_WID` and `ZED_VERIFY_DATA_DIR=/tmp/zed-verify-open1`.
- **Doctor.** Run `control-zed doctor --id open1`. Expect `doctor: PASS`.
- **Confirm workspace title.** Run `control-zed title --id open1`. Title contains `sample-project` or `Zed`.
- **Screenshot.** Run `control-zed screenshot --id open1 --out .cursor/skills/verify-zed/artifacts/open1/workspace.png`. Image shows the editor chrome (not an empty desktop).
- **Proof.** Artifact `workspace.png` plus doctor PASS. Data dir is under `/tmp/zed-verify-open1`, not `~/.config/zed`.

## Gotchas

- First launch can take tens of seconds while GPUI/Vulkan initializes; raise `--timeout` if needed.
- Window class for dev builds is `dev.zed.Zed-Dev`, not plain `Zed`.
- Without `ZED_ALLOW_EMULATED_GPU=1`, llvmpipe hosts show an Unsupported GPU modal that steals all keys — the harness sets this env var.
- A fresh `--user-data-dir` always shows the Unrecognized Project trust modal; `launch` presses Enter (Trust and Continue).
- Do not open the user's real home projects when proving isolation.
