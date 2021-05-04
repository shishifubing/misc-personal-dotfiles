#!/usr/bin/env bash

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# stuff
# {{{

# source functions
[[ -f ~/dot-files/scripts/shell_functions.sh ]] &&
    . ~/dot-files/scripts/shell_functions.sh
# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"
# enable programmable completion features
# you don't need to enable this,
# if it's already enabled in /etc/bash.bashrc and /etc/profile
[[ -f /usr/share/bash-completion/bash_completion ]] &&
    . /usr/share/bash-completion/bash_completion
[[ -f /etc/bash_completion ]] &&
    . /etc/bash_completion

# }}}

# shell options
# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
# {{{

# vim mode for the terminal
set -o vi
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# minor errors in the spelling of a directory in a cd command will be corrected
shopt -s cdspell
# Bash will attempt spelling correction on directory names during word completion
shopt -s dirspell
# Bash will include filenames beginning with a ‘.’ in the results of filename expansion
shopt -s dotglob
# Bash will send SIGHUP to all jobs when an interactive login shell exits
shopt -s huponexit
# Bash will matche filenames in a case-insensitive fashion when performing filename expansion.
shopt -s nocaseglob
# flushes the command to the history file immediately
# otherwise, this would happen only when the shell exits
shopt -s histappend
# Bash will attempt to save all lines of a multiple-line
# command in the same history entry.
shopt -s cmdhist

# }}}

# random variables
# {{{

# all locales are overwritten
export LC_ALL="en_US.UTF-8"
# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# }}}

# bash history
# {{{

# history file location
export HISTFILE=~/.bash_history
# what commands to put in history
# "ignoreboth:erasedups" -
#   don't put duplicate lines or lines
#   starting with space in the bash history.
export HISTCONTROL=
# unlimited bash history (file size)
export HISTFILESIZE=
# unlimited bash history (lines)
export HISTSIZE=
# }}}

# start stuff
# {{{

# start xorg on login
[[ -z "${DISPLAY}" && "${XDG_VTNR}" -eq 1 ]] && start_xorg_server
# trap DEBUG is executed before each command
# (even if they are written on the same line)
# (including PROMPT_COMMAND)
# because of the condition it is executed only one time
trap '[[ -z "${TRAP_DEBUG_TIME_START}" ]] && execute_before' DEBUG
# PROMPT_COMMAND is executed after every command
export PROMPT_COMMAND='execute_after'

# }}}
