#!/usr/bin/env bash
# Builds the voice extension on Linux and copies it to the repo root for `hemtt release`:
#   acre_voice_x64.dll  Windows clients and servers (cross-compiled with mingw)
#   acre_voice_x64.so   Linux dedicated servers (no audio devices)
#
# Usage: ./build-extension.sh [windows|linux|all]   (default: all)
#
# Needs: rustup with the x86_64-pc-windows-gnu target, mingw-w64-gcc, and CMake (libopus is
# compiled in).
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="${1:-all}"

need() {
    command -v "$1" >/dev/null 2>&1 || { echo "error: $1 not found. $2" >&2; exit 1; }
}

need cargo "Install Rust from https://rustup.rs"
need cmake "Install it with your package manager (e.g. sudo dnf install cmake) or pip install --user cmake"

build_windows() {
    need x86_64-w64-mingw32-gcc "Install mingw (e.g. sudo dnf install mingw64-gcc)"
    rustup target list --installed | grep -qx x86_64-pc-windows-gnu ||
        rustup target add x86_64-pc-windows-gnu
    echo "==> Building acre_voice_x64.dll (Windows)"
    (cd "$root/rust" && cargo build --release -p acre2_ext \
        --target x86_64-pc-windows-gnu --features acre2_voice_codec/bundled)
    cp "$root/rust/target/x86_64-pc-windows-gnu/release/acre_voice.dll" "$root/acre_voice_x64.dll"
}

build_linux() {
    echo "==> Building acre_voice_x64.so (Linux server)"
    (cd "$root/rust" && cargo build --release -p acre2_ext \
        --no-default-features --features acre2_voice_codec/bundled)
    cp "$root/rust/target/release/libacre_voice.so" "$root/acre_voice_x64.so"
}

case "$target" in
    windows) build_windows ;;
    linux) build_linux ;;
    all) build_windows; build_linux ;;
    *) echo "usage: $0 [windows|linux|all]" >&2; exit 1 ;;
esac

echo "==> Done:"
ls -l "$root"/acre_voice_x64.* 2>/dev/null
echo "Now run: hemtt release"
