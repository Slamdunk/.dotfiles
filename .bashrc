#!/bin/bash

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [ -z "$PHPSTORM" ]; then
    exec tmux new -ADs def && exit
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

HISTTIMEFORMAT='%F %T   '

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=500000
HISTFILESIZE=10000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

C_RED="\\[\\033[0;31m\\]"
C_GREEN="\\[\\033[0;32m\\]"
C_BROWN="\\[\\033[0;33m\\]"
C_BLUE="\\[\\033[0;34m\\]"
C_PURPLE="\\[\\033[0;35m\\]"
C_CYAN="\\[\\033[0;36m\\] "
C_GRAY="\\[\\033[1;30m\\]"
C_WHITE="\\[\\033[1;37m\\]"
C_YELLOW="\\[\\033[1;33m\\]"
C_LIGHT_GRAY="\\[\\033[0;37m\\]"
C_LIGHT_BLUE="\\[\\033[1;34m\\]"
C_LIGHT_CYAN="\\[\\033[1;36m\\]"
C_LIGHT_PURPLE="\\[\\033[1;35m\\]"
C_LIGHT_RED="\\[\\033[1;31m\\]"
C_LIGHT_GREEN="\\[\\033[1;32m\\]"
C_YELLOW_RED_BG="\\[\\033[01;33;41m\\]"
C_RESET="\\[\\033[0m\\]"

sign="\$"
user_color="$C_YELLOW"
case "$USER" in
    root)
        sign="#"
        user_color="$C_LIGHT_RED"
        ;;
    slam|tessarotto)
        user_color="$C_LIGHT_GREEN"
        ;;
    code)
        user_color="$C_LIGHT_CYAN"
        ;;
esac

GIT_PS1_SHOWDIRTYSTATE='y'
GIT_PS1_SHOWSTASHSTATE='y'
GIT_PS1_SHOWUNTRACKEDFILES='y'
GIT_PS1_SHOWUPSTREAM='auto'

if [ "$color_prompt" = yes ]; then
    PS1="${debian_chroot:+($debian_chroot)}\`if [ \$? = 0 ]; then echo \"${user_color}\"; else echo \"${C_YELLOW_RED_BG}\"; fi\`\\u@\\h${C_RESET}:${C_LIGHT_BLUE}\\w${C_YELLOW}"'$(__git_ps1 2> /dev/null)'"${C_RESET}${sign} "
else
    PS1="${debian_chroot:+($debian_chroot)}\\u@\\h:\\w${sign} "
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
linux|xterm*|rxvt*)
  export PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME%%.*}:${PWD##*/}\007"'
  ;;
screen*)
  export PROMPT_COMMAND='echo -ne "\033k${HOSTNAME%%.*}:${PWD##*/}\033\\" '
  ;;
*)
  ;;
esac

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ "$USER" == "root" ]; then
    umask 0022
else
    umask 0027
fi

export EDITOR=vim

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors --sh)"
    alias ls='ls --color=auto'

    alias grep="grep --color=auto"
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias grep="grep --exclude-dir=.cvs --exclude-dir=.git --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.work"

# some more ls aliases
alias ll='ls -alhF'

alias rm='rm -vI'
alias mv='mv -v'
alias cp='cp -v'

alias gzip='gzip -v'
alias gunzip='gunzip -v'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

if [ -f ~/.config/fzf/fzf.bash ]; then
    . ~/.config/fzf/fzf.bash
fi

genpasswd() {
    local l=$1
    [ "$l" == "" ] && l=32
    tr -dc ABCDEFGHKMNPQRSTUVWXYZabcdefghkmnpqrstuvwxyz23456789_ < /dev/urandom | head -c ${l} | xargs
}
