#!/usr/bin/env bash

force_color_prompt=yes

### start
## if the shell is not interactive - return
[[ "${-}" == *"i"* ]] || return
## if source script is not present - return
. "${HOME}/dotfiles/scripts/functions/source_stuff.sh" || return

### source stuff
## source functions from the folder 'functions'
source_functions
## source programmable completion
source_programmable_completion_features
## source fzf scripts
source_fzf_scripts
## source keymaps, doesn't work in kde on startup
#source_keymaps_on_start
## shell options
set_shell_options

### export
## less
export_variables_less
## bash history
export_variables_bash_history
## colors
export_variables_colors
## other
export_variables_others
## add binaries to PATH
#export_binaries
## export all declared functions, not POSIX
## can cause problems on some systems (rhel 7, for example)
export_declared_functions

### start stuff
## preexec and precmd hooks
start_preexec_precmd
## asks to start an xorg server if it is not running already
start_xorg_server
## outputs system information (kernel, gcc)
get_distribution_info

