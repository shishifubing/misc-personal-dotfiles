#!/usr/bin/env bash

## if shell is not interactive - return
[[ "${-}" == *"i"* || "${1}" != "script" ]] || return
## if source script is not present - return
export DOTFILES="${HOME}/Dotfiles"
export DOTFILES_SOURCE="${DOTFILES}/scripts/source_functions.sh"
. "${DOTFILES_SOURCE}" || return

set_shell_options
export_variables_less
export_variables_bash_history
export_variables_colors
export_variables_others