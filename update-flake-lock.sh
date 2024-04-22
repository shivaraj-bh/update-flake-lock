#!/usr/bin/env bash
set -euo pipefail

options=()
if [[ -n "$NIX_OPTIONS" ]]; then
    for option in $NIX_OPTIONS; do
        options+=("${option}")
    done
fi

if [[ -n "$TARGETS" ]]; then
    inputs=()
    for input in $TARGETS; do
        inputs+=("--update-input" "$input")
    done
    if [[ -n "$PATH_TO_FLAKE_DIRS" ]]; then
        for dir in $PATH_TO_FLAKE_DIRS; do
            nix "${options[@]}" flake lock "${inputs[@]}" --commit-lock-file --commit-lockfile-summary "$COMMIT_MSG" "$dir"
        done
    else
        nix "${options[@]}" flake lock "${inputs[@]}" --commit-lock-file --commit-lockfile-summary "$COMMIT_MSG"
    fi
else
    if [[ -n "$PATH_TO_FLAKE_DIRS" ]]; then
        for dir in $PATH_TO_FLAKE_DIRS; do
            nix "${options[@]}" flake update --commit-lock-file --commit-lockfile-summary "$COMMIT_MSG" --flake "$dir"
        done
    else
        nix "${options[@]}" flake update --commit-lock-file --commit-lockfile-summary "$COMMIT_MSG"
    fi
fi
