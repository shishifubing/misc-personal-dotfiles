#!/usr/bin/env bash

# declared functions
export_declared_functions() {

    mapfile -t "functions" <<<"$(get_declared_functions)"
    export -f "${functions[@]}"

}

# less variables
# https://www.topbug.net/blog/2016/09/27/make-gnu-less-more-powerful/
export_variables_less() {

    # --quit-if-one-screen --ignore-case --status-column --LONG-PROMPT
    # --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4
    local reset=$(echo -e "$(get_color_end -)")
    local bold=$(echo -e "$(get_color - 31)")
    local blink=$(echo -e "$(get_color - 34)")
    local underline=$(echo -e "$(get_color - 04 01 32)")
    local reverse_video=$(echo -e "$(get_color - 01 44 37)")

    export LESS="-F -i -J -M -R -W -x4 -X -z-4"
    export LESS_TERMCAP_mb=${bold}          # begin bold
    export LESS_TERMCAP_md=${blink}         # begin blink
    export LESS_TERMCAP_me=${reset}         # reset bold/blink
    export LESS_TERMCAP_so=${reverse_video} # begin reverse video
    export LESS_TERMCAP_se=${reset}         # reset reverse video
    export LESS_TERMCAP_us=${underline}     # begin underline
    export LESS_TERMCAP_ue=${reset}         # reset underline

}

# history variables
export_variables_bash_history() {

    # history file location
    export HISTFILE="${HOME}/.bash_history"
    # what commands to put in history
    # "ignoreboth:erasedups" -
    #   don't put duplicate lines or lines
    #   starting with space in the bash history.
    export HISTCONTROL=
    # unlimited bash history (file size)
    export HISTFILESIZE=
    # unlimited bash history (number of lines)
    export HISTSIZE=

}

# other variables
export_variables_others() {

    # all locales are overwritten
    export LC_ALL="en_US.UTF-8"
    # colored GCC warnings and errors
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
    # path edit for ruby gems to work
    export PATH="${PATH}:${HOME}/.local/share/gem/ruby/3.0.0/bin"
    # fzf
    export FZF_DEFAULT_OPTS="--height=50% --layout=reverse --border=none --margin=0 --padding=0"
}
