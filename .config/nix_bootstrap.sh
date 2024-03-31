#!/usr/bin/env bash

if command -v apt &> /dev/null; then # apt
    sudo xargs apt -y install <nix_deps.txt
fi

rm -rf "$HOME/Library/Application Support/nushell"
mkdir -p "$HOME/Library/Application Support/nushell"
ln -s "$HOME/Library/Application Support/nushell" $HOME/.config/nushell
