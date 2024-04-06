#!/usr/bin/env bash

if command -v apt &> /dev/null; then # apt
    sudo xargs apt -y install <nix_deps.txt
fi

rm -rf "$HOME/Library/Application Support/nushell"
mkdir -p "$HOME/Library/Application Support/nushell"
ln -s $HOME/.config/nushell/config.nu "$HOME/Library/Application Support/nushell/config.nu"
ln -s $HOME/.config/nushell/env.nu "$HOME/Library/Application Support/nushell/env.nu"
