#!/usr/bin/env bash

## if not running interactively, don't do anything
# check whether this shell has just executed a prompt
# and is waiting for user input or not
[[ "${-}" != *"i"* ]] && return

. "${HOME}/dot-files/scripts/functions.sh" || return
enable_programmable_completion_features
set_shell_options
export_variables_less
export_variables_bash_history
export_variables_others
bashrc_start_stuff
