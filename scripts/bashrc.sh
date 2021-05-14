#!/usr/bin/env bash

[[ "${-}" == *"i"* ]] && . "${HOME}/dot-files/scripts/functions/source_stuff.sh" && {

    source_functions
    source_programmable_completion_features
    source_fzf_scripts
    source_keymaps_on_start

    set_shell_options

    export_variables_less
    export_variables_bash_history
    export_variables_colors
    export_variables_others
    export_declared_functions

    start_preexec_precmd
    start_xorg_server
    [[ "${__is_not_first_launch}" ]] || preexec
    get_distribution_info

}
