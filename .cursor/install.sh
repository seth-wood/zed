#!/usr/bin/env bash
# Cloud Agent environment bootstrap for the Zed fork.
# Idempotent: safe to re-run on cached or partially prepared VMs.
set -euo pipefail

cd "$(dirname "$0")/.."

./script/linux

# Soft Vulkan for GPUI / Zed GUI verification on llvmpipe hosts.
sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mesa-vulkan-drivers

# Warm the Rust toolchain and crate index so agents start ready to build.
if command -v rustup >/dev/null 2>&1; then
  rustup show >/dev/null
fi
cargo fetch

echo "Cursor install complete."
