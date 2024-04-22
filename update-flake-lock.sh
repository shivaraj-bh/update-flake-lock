#!/usr/bin/env bash
set -euo pipefail

options=()
if [[ -n "$NIX_OPTIONS" ]]; then
    for option in $NIX_OPTIONS; do
        options+=("${option}")
    done
fi

flake_dirs=()
if [[ -n "$PATH_TO_FLAKE_DIRS" ]]; then
    for dir in $PATH_TO_FLAKE_DIRS; do
        flake_dirs+=("--flake" "$dir")
    done
fi

nix "${options[@]}" flake update "$TARGETS" --commit-lock-file --commit-lockfile-summary "$COMMIT_MSG" "${flake_dirs[@]}"
