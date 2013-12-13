#!/usr/bin/env bash

set -ex

DOTFILES_ROOT="$(readlink -f $(dirname "$0"))"

suffix=".""$(date +%y%m%d.%H%M)"".bck"

if [ "$USER" == "root" ]; then
    for file in "profile:/etc/profile" "bashrc:/etc/bash.bashrc" "vimrc:/etc/vim/vimrc.local"; do
        from="$(echo -n "$file" | sed 's/:.*//g')"
        to="$(echo -n "$file" | sed 's/.*://g')"

        if [ -f "$to" ] && ! [ -h "$to" ]; then
            mv "$to" "$DOTFILES_ROOT""/backup/""$(echo -n "$to" | sed 's/\//_/g')""$suffix"
        else
            rm -f "$to"
        fi

        ln -s "$DOTFILES_ROOT""/""$from" "$to"
    done

    for file in "/etc/skel/.bashrc" "/etc/skel/.profile"; do
        if [ -f "$file" ]; then
            mv "$file" "$DOTFILES_ROOT""/backup/""$(echo -n "$file" | sed 's/\//_/g')""$suffix"
        fi
    done

    for file in ".bashrc" ".profile"; do
        rm -f "$HOME""/""$file"
    done

    exit
fi

for file in .gitconfig .hgrc .vimrc .bashrc .profile; do
    rm -f "$HOME""/""$file"
done

for file in gitconfig hgrc; do
    ln -s "$DOTFILES_ROOT""/""$file" "$HOME""/.""$file"
done
