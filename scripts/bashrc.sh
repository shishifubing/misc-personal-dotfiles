#!/usr/bin/env bash

force_color_prompt=yes

[[ "${-}" == *"i"* ]] || return
. "${HOME}/dot-files/scripts/functions/source_stuff.sh" || return

## source functions from the folder
source_functions
## source programmable completion
source_programmable_completion_features
source_fzf_scripts
## doesn't work in kde on startup
source_keymaps_on_start

set_shell_options

export_variables_less
export_variables_bash_history
export_variables_colors
export_variables_others
## add binaries to PATH
export_binaries
## export all declared functions, not POSIX
## can cause problems on some systems (rhel 7, for example)
export_declared_functions

start_preexec_precmd
start_xorg_server
get_distribution_info

