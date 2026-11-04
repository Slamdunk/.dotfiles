#!/bin/bash

thisDir=$(readlink --canonicalize "$(dirname "$0")")

for file in \
    ".bashrc" \
    ".gitconfig" \
    ".config/git/ignore" \
    ".tmux.conf" \
    ".vimrc" \
    ".wgetrc" \
; do
    destination=~/"$file"
    newfile="${thisDir:?}""/""$file"
    if [ -f "$destination" ]; then
        diffOutput=$(diff -u --color=always "$destination" "$newfile")
        [ $? = 1 ] || continue
        if [ "$1" != "--non-interactive" ]; then
            echo "$diffOutput"
            read -p "Update [""$file""] ? " -n 1 -r < /dev/tty
            echo
            [[ "$REPLY" =~ ^[Yy]$ ]] || continue
        fi
    fi

    mkdir -p "$(dirname "$destination")"
    cp -av "$newfile" "$destination"
done
