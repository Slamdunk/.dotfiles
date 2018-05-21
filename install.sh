#!/bin/sh

set -ex

DOTFILES_ROOT="$(readlink --canonicalize "$(dirname "$0")")"

suffix=".""$(date +%y%m%d.%H%M)"".bck"

if [ "$DOTFILES_ROOT" != "/etc/.dotfiles" ]; then
    for file in "bashrc:profile" "bashrc:bashrc" "vimrc:vimrc" "gitconfig:gitconfig" "wgetrc:wgetrc"; do
        from="$(printf "%s" "$file" | sed 's/:.*//g')"
        to="$HOME""/.""$(printf "%s" "$file" | sed 's/.*://g')"

        if [ -f "$to" ] && ! [ -h "$to" ]; then
            mv --verbose "$to" "$DOTFILES_ROOT""/backup/""$(printf "%s" "$to" | sed 's/\//_/g')""$suffix"
        else
            rm --force --verbose "$to"
        fi

        cp --verbose "$DOTFILES_ROOT""/""$from" "$to"
    done

    exit
fi

if [ "$USER" = "root" ]; then
    for file in "profile:/etc/profile" "bashrc:/etc/bash.bashrc" "vimrc:/etc/vim/vimrc.local"; do
        from="$(printf "%s" "$file" | sed 's/:.*//g')"
        to="$(printf "%s" "$file" | sed 's/.*://g')"

        if [ -f "$to" ] && ! [ -h "$to" ]; then
            mv --verbose "$to" "$DOTFILES_ROOT""/backup/""$(printf "%s" "$to" | sed 's/\//_/g')""$suffix"
        else
            rm --force --verbose "$to"
        fi

        ln -s "$DOTFILES_ROOT""/""$from" "$to"
    done

    for file in "/etc/skel/.bashrc" "/etc/skel/.profile"; do
        if [ -f "$file" ]; then
            mv --verbose "$file" "$DOTFILES_ROOT""/backup/""$(printf "%s" "$file" | sed 's/\//_/g')""$suffix"
        fi
    done

    for file in ".bashrc" ".profile"; do
        rm --force --verbose "$HOME""/""$file"
    done

    exit
fi

for file in .gitconfig .hgrc .vimrc .bashrc .profile; do
    rm --force --verbose "$HOME""/""$file"
done

for file in gitconfig hgrc; do
    ln -s "$DOTFILES_ROOT""/""$file" "$HOME""/.""$file"
done
