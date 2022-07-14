#!/usr/bin/env bash

if command -v apt &> /dev/null; then # apt
    sudo xargs apt -y install <nix_deps.txt
fi
