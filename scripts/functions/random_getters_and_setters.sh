#!/usr/bin/env bash

# random getters and setters

# shell options
# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
set_shell_options() {

    # vim mode for the terminal
    set -o vi
    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize
    # minor errors in the spelling of a directory in a cd command will be corrected
    shopt -s cdspell
    # attempt spelling correction on directory names during word completion
    shopt -s dirspell
    # include filenames beginning with a ‘.’ in the results of filename expansion
    shopt -s dotglob
    # send SIGHUP to all jobs when an interactive login shell exits
    shopt -s huponexit
    # match filenames in a case-insensitive fashion when performing filename expansion.
    shopt -s nocaseglob
    # flushes the command to the history file immediately
    # otherwise, this would happen only when the shell exits
    shopt -s histappend
    # attempt to save all lines of a multiple-line
    # command in the same history entry.
    shopt -s cmdhist

}

# get terminal width
get_terminal_width() {

    stty size | awk '{ print $(2) }'

}

# get distribution info
get_distribution_info() {

    local output=$(</proc/version)

    echo "${output}"

}

# get list of functions
get_declared_functions() {

    declare -F | awk '{ print $(3) }'

}

# return extension of the string provided
get_file_type() {

    awk -F'[.]' '{ print $(NF) }' <<<"${1}"

}

# get directory
get_directory() {

    pwd | awk -F'[/]' '{ print $(NF-1) "/" $(NF) }'

}

# set window title
set_window_title() {

    local output="\033]0;${1}\007"

    echo -ne "${output}"

}

# get current git branch
get_current_branch() {

    git branch --show-current 2>/dev/null

}

# get name of the process by PID
get_name_of_the_process() {

    ps -p "${1}" -o comm=

}
