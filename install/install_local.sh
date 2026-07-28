#!/usr/bin/env bash
# install_local.sh — deprecated, use install/install.sh instead.
echo "==> install_local.sh is now part of install.sh"
echo "==> Run:  ./install/install.sh"
echo "==> Select 'Local' when prompted."
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/install.sh" --mode local
