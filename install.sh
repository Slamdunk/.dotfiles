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

# Migration notices
if [ -f ~/.gitignore ] && [ -z "$(git config --global core.excludesfile 2> /dev/null)" ]; then
    echo
    echo "NOTICE: git now uses ~/.config/git/ignore as global ignore file: ~/.gitignore can be removed"
fi
if command -v git &> /dev/null && [ -z "$(git config --global --includes user.email)" ]; then
    echo
    echo "NOTICE: no git identity set; add it to the untracked ~/.gitconfig.local:"
    echo "    git config --file ~/.gitconfig.local user.name  \"Your Name\""
    echo "    git config --file ~/.gitconfig.local user.email \"you@example.com\""
fi

# Missing packages hint (Debian/Ubuntu)
missing=()
for pair in git:git vim:vim tmux:tmux fzf:fzf rg:ripgrep curl:curl; do
    command -v "${pair%%:*}" &> /dev/null || missing+=("${pair##*:}")
done
[ -f /usr/share/bash-completion/bash_completion ] || missing+=("bash-completion")
if [ -n "$XDG_CURRENT_DESKTOP" ]; then
    if [ -n "$WAYLAND_DISPLAY" ]; then
        command -v wl-copy &> /dev/null || missing+=("wl-clipboard")
    else
        command -v xclip &> /dev/null || missing+=("xclip")
    fi
fi
if [ ${#missing[@]} -gt 0 ]; then
    echo
    echo "Suggested packages not installed:"
    echo "    sudo apt install ${missing[*]}"
fi
