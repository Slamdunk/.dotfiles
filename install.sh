#!/usr/bin/env bash

set -ex

DOTFILES_ROOT="$(readlink -f $(dirname "$0"))"

suffix=".""$(date +%y%m%d.%H%M)"".bck"

if [ "$USER" == "root" ]; then
    chmod 0755 "$DOTFILES_ROOT"
    chmod 0644 "$DOTFILES_ROOT"/*

    for file in "profile:/etc/profile" "bashrc:/etc/bash.bashrc" "vimrc:/etc/vim/vimrc.local"; do
        from="$(echo -n "$file" | sed 's/:.*//g')"
        to="$(echo -n "$file" | sed 's/.*://g')"

        if [ -f "$to" ]; then
            mv "$to" "$to""$suffix"
        else
            rm -f "$to"
        fi

        ln -s "$DOTFILES_ROOT""/""$from" "$to"
    done

    exit
fi
