#!/usr/bin/env bash

# if not running interactively, don't do anything
# check whether this shell has just executed a prompt
# and is waiting for user input or not
[[ "${-}" != *i* ]] && return

# source stuff
# {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

# source functions
. "${HOME}/dot-files/scripts/functions.sh"
#
# enable programmable completion features
# you don't need to enable this if it's
# already enabled in /etc/bash.bashrc and /etc/profile
source_files_if_exist "/usr/share/bash-completion/bash_completion"
source_files_if_exist "/etc/bash_completion"

# }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

# shell options
# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
# {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

# vim mode for the terminal
set -o vi
#
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
#
# minor errors in the spelling of a directory in a cd command will be corrected
shopt -s cdspell
#
# attempt spelling correction on directory names during word completion
shopt -s dirspell
#
# include filenames beginning with a ‘.’ in the results of filename expansion
shopt -s dotglob
#
# send SIGHUP to all jobs when an interactive login shell exits
shopt -s huponexit
#
# match filenames in a case-insensitive fashion when performing filename expansion.
shopt -s nocaseglob
#
# flushes the command to the history file immediately
# otherwise, this would happen only when the shell exits
shopt -s histappend
#
# attempt to save all lines of a multiple-line
# command in the same history entry.
shopt -s cmdhist

# }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

# random variables
# {{{

# all locales are overwritten
export LC_ALL="en_US.UTF-8"
#
# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
#
# path edit for ruby gems to work
export PATH="${PATH}:${HOME}/.local/share/gem/ruby/3.0.0/bin"

# }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

# less
# https://www.topbug.net/blog/2016/09/27/make-gnu-less-more-powerful/
# {{{

# set options for less
# --quit-if-one-screen --ignore-case --status-column --LONG-PROMPT
# --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4
export LESS="-F -i -J -M -R -W -x4 -X -z-4"
export LESS_TERMCAP_mb=$(echo -e "$(get_color - 31)")       # begin bold
export LESS_TERMCAP_md=$(echo -e "$(get_color - 34)")       # begin blink
export LESS_TERMCAP_me=$(echo -e "$(get_color_end -)")      # reset bold/blink
export LESS_TERMCAP_so=$(echo -e "$(get_color - 01 44 37)") # begin reverse video
export LESS_TERMCAP_se=$(echo -e "$(get_color_end -)")      # reset reverse video
export LESS_TERMCAP_us=$(echo -e "$(get_color - 04 01 32)") # begin underline
export LESS_TERMCAP_ue=$(echo -e "$(get_color_end -)")      # reset underline

# }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

# bash history
# {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

# history file location
export HISTFILE="${HOME}/.bash_history"
#
# what commands to put in history
# "ignoreboth:erasedups" -
#   don't put duplicate lines or lines
#   starting with space in the bash history.
export HISTCONTROL=
#
# unlimited bash history (file size)
export HISTFILESIZE=
#
# unlimited bash history (number of lines)
export HISTSIZE=

# }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

# start stuff
# {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

# start xorg on login
[[ -z "${DISPLAY}" && "${XDG_VTNR}" -eq 1 ]] && start_xorg_server
#
# trap DEBUG is executed before each command
# (even if they are written on the same line)
# (including PROMPT_COMMAND)
# because of the condition it is executed only one time
trap '[[ -z "${TRAP_DEBUG_TIME_START}" ]] && preexec' DEBUG
#
# PROMPT_COMMAND is executed before each prompt
export PROMPT_COMMAND='precmd'
#
# message
echo ".bashrc is sourced"
echo
echo "$(</proc/version)"

# }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}