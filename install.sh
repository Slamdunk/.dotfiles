#!/bin/bash

thisDir=$(readlink --canonicalize "$(dirname "$0")")

for file in \
    ".bashrc" \
    ".gitconfig" \
    ".tmux.conf" \
    ".vimrc" \
    ".wgetrc" \
; do
    destination=~/"$file"
    newfile="${thisDir:?}""/""$file"
    if [ -f "$destination" ]; then
        diffOutput=$(diff "$destination" "$newfile")
        [ $? = 1 ] || continue
        echo "$diffOutput"

		read -p "Update [""$file""] ? " -n 1 -r < /dev/tty
		echo
		[[ "$REPLY" =~ ^[Yy]$ ]] || continue
    fi

	cp -av "$newfile" "$destination"
done
