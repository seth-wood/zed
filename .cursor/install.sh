#!/usr/bin/env bash
set -euo pipefail

# Cloud Agent install step for Zed.
#
# Runs after the repository is checked out. It installs the Linux system
# libraries required to build Zed and then pre-fetches the Cargo registry and
# git dependencies so later `cargo build` / `cargo run` compiles do not depend
# on network access.

# `script/linux` installs packages via apt-get. fuse3 ships a conffile
# (/etc/fuse.conf) that triggers an interactive dpkg prompt, which would hang a
# non-interactive install. Force dpkg to keep the existing config so the whole
# dependency install stays non-interactive and idempotent.
export DEBIAN_FRONTEND=noninteractive
printf 'Dpkg::Options { "--force-confdef"; "--force-confold"; };\n' \
  | sudo tee /etc/apt/apt.conf.d/99-cursor-noninteractive > /dev/null

script/linux

# Cloud Agent VMs are headless and have no real GPU, but Zed's GPUI renderer
# requires a Vulkan driver (ICD) to open a window. Install Mesa's software
# rasterizer (lavapipe) so the GUI can run for manual testing. Run Zed with
# `VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/lvp_icd.json ZED_ALLOW_EMULATED_GPU=1`.
sudo apt-get install -y mesa-vulkan-drivers

# Warm the dependency cache. Uses the committed Cargo.lock so no versions are
# changed during setup.
cargo fetch --locked
