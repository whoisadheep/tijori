#!/usr/bin/env bash
# Tijori Desktop Launcher
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
export GDK_BACKEND=x11
exec "$DIR/build/linux/x64/debug/bundle/tijori" "$@"
