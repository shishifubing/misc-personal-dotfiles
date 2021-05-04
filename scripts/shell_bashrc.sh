#!/usr/bin/env bash

source ~/dot-files/scripts/shell_functions.sh
set -o vi

# if not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# if set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
shopt -oq posix || enable_programmable_completion_features

# random variables
# {{{

export LC_ALL="en_US.UTF-8" # all locales are overwritten
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# colored GCC warnings and errors

# }}}

# bash history
# {{{

export HISTFILE=~/.bash_history # bash history
export HISTCONTROL=             # put everything in history
#"ignoreboth:erasedups"
# don't put duplicate lines or lines starting with space in the bash history.
export HISTFILESIZE= # unlimited bash history (file size)
export HISTSIZE=     # unlimited bash history (lines)
shopt -s histappend  # append to the history file, don't overwrite it
# flushes the command to the history file immediately
# otherwise, this would happen only when the shell exits

# }}}

# bindings
# {{{

#bind -x '"\e[A": history_item' # up arrow
#bind -x '"\e[B": history_item' # down arrow
#setxkbmap -option caps:escape # remaps caps lock to escape. Only in terminal

# }}}

# start stuff
# {{{

# start xorg on login
[[ -z "${DISPLAY}" && "${XDG_VTNR}" -eq 1 ]] && start_xorg_server
# trap DEBUG is executed before each command
# (even if they are written on the same line)
# (including PROMPT_COMMAND)
# because of the condition it is executed only one time
trap '[[ -z "${TRAP_DEBUG_START_TIME}" ]] && execute_before' DEBUG
# PROMPT_COMMAND is executed after every command
export PROMPT_COMMAND='execute_after'

# }}}
