#!/usr/bin/env bash

# if not running interactively, don't do anything
[[ "${-}" != *"i"* ]] && return

. "${HOME}/dot-files/scripts/functions/source_stuff.sh" || return

source_scripts_in_directory "${HOME}/dot-files/scripts/functions"
source_programmable_completion_features
source_fzf_scripts

set_shell_options

export_variables_less
export_variables_bash_history
export_variables_others
export_declared_functions

start_preexec_precmd
start_xorg_server
get_distribution_info
