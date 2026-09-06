---
name: verify-zed
description: Drive the real Zed desktop editor on Linux/X11 to prove user-facing behavior. Use when verifying editor features (open project, command palette, file finder, edit/save, project panel) with screenshots and disposable --user-data-dir isolation.
---

# Verify Zed

Drive the real Zed GUI the way a user does. Do not treat `cargo test`, GPUI unit tests, or the macOS-only visual test runner as sufficient proof of user-facing behavior.

Primary surface: **Zed desktop editor** (GPUI on X11 in this environment). Secondary surfaces (CLI IPC into a running editor, collab server, extensions) are out of scope for the initial map unless a feature file says otherwise.

## Launch

Build once from the repo root (debug is fine for verification):

```bash
cargo build -p zed
```

Optional: `cargo build -p cli` if you also need the `zed` launcher binary. This skill runs `target/debug/zed` (or `ZED_BIN`) directly.

Start an isolated instance via the harness:

```bash
CTRL=.cursor/skills/verify-zed/scripts/control-zed
$CTRL launch --id demo --display "${DISPLAY:-:1}"
```

`launch` sets `ZED_ALLOW_EMULATED_GPU=1` (required on Cloud/llvmpipe hosts; otherwise an Unsupported GPU modal blocks input) and dismisses the first-run Unrecognized Project trust modal with Enter. Ready when `launch` prints `ZED_VERIFY_WID=...` (a visible window owned by the new PID). Default project is `.cursor/skills/verify-zed/fixtures/sample-project`. Override with `--project /abs/path`.

Teardown:

```bash
$CTRL cleanup --id demo
```

Cleanup kills the PID this run started and removes `/tmp/zed-verify-<id>`. It never deletes evidence under `.cursor/skills/verify-zed/artifacts/`.

### Isolation rules

- Always pass `--user-data-dir /tmp/zed-verify-<id>` (the harness does this). Never use `~/.config/zed` or `~/.local/share/zed`.
- Never drive a Zed window you did not launch in this verification run.
- Two instances may run side by side if each has a unique `--id` / data dir and you focus by PID via the harness.
- Set `DISPLAY` to the X11 display under test (Cloud VMs typically use `:1`).

## Doctor

Before any drive step when something looks off:

```bash
$CTRL doctor --id demo
```

Doctor is read-only. It checks: process alive, binary path matches launch, data dir exists under `/tmp/zed-verify-*`, and a visible window is owned by that PID. On FAIL, do not send keys — relaunch or read `ZED_VERIFY_LOG`.

## Drive

Harness: `.cursor/skills/verify-zed/scripts/control-zed` (xdotool + ImageMagick `import`).

```bash
$CTRL key --id demo ctrl+shift+p          # command palette (also F1)
$CTRL key --id demo ctrl+p                # file finder
$CTRL key --id demo ctrl+shift+e          # project panel focus
$CTRL key --id demo ctrl+s                # save
$CTRL type --id demo --text 'hello'
$CTRL title --id demo
$CTRL wait-title --id demo --pattern hello.txt
$CTRL screenshot --id demo --out .cursor/skills/verify-zed/artifacts/demo/after.png
```

Linux default bindings live in `assets/keymaps/default-linux.json`. Prefer those action names and keys over coordinates.

Stable handles:

| User intent | Key / action |
| --- | --- |
| Command palette | `ctrl+shift+p` or `F1` → `command_palette::Toggle` |
| File finder | `ctrl+p` → `file_finder::Toggle` |
| Project panel | `ctrl+shift+e` → `project_panel::ToggleFocus` |
| New file | `ctrl+n` → `workspace::NewFile` |
| Save | `ctrl+s` → `workspace::Save` |
| Left dock | `ctrl+b` → `workspace::ToggleLeftDock` |

Optional: launch sets `ZED_EXPERIMENTAL_A11Y=1` so AccessKit/AT-SPI may expose the tree; prefer window title + screenshots + on-disk file side effects as proof until AT-SPI dumps are wired into the harness.

## Evidence

Store proofs under:

```text
.cursor/skills/verify-zed/artifacts/<run-id>/
```

Required for a passing proof:

1. Exercise a real user path from `features/` (not an internal test setter).
2. Capture the action and the resulting state (screenshot before/after or title change + screenshot after).
3. For mutations, verify the side effect on disk (file contents under the fixture project or the disposable data dir), not only pixels.
4. Record the feature id and commands used in a short `proof.md` next to the screenshots.

Proof standards: no mocks of the editor UI; do not claim success from unit-test output alone.

## Cleanup

```bash
$CTRL cleanup --id demo
```

Kills only the recorded PID. Removes only `/tmp/zed-verify-<id>`. Leaves `.cursor/skills/verify-zed/artifacts/**` intact.

## Helpers

| Helper | Invocation |
| --- | --- |
| Harness | `.cursor/skills/verify-zed/scripts/control-zed <subcommand>` |
| Fixture project | `.cursor/skills/verify-zed/fixtures/sample-project/` |

`control-zed help` lists subcommands. Set `ZED_BIN` to override binary discovery.

## Feature map

Read `features/README.md`, then the feature file for the behavior under test.
