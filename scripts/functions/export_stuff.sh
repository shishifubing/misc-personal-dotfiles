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
    export LESS="-F -i -J -M -R -W -x4 -X -z-4"
    export LESS_TERMCAP_mb=$(echo -e "$(get_color - 31)")       # begin bold
    export LESS_TERMCAP_md=$(echo -e "$(get_color - 34)")       # begin blink
    export LESS_TERMCAP_me=$(echo -e "$(get_color_end -)")      # reset bold/blink
    export LESS_TERMCAP_so=$(echo -e "$(get_color - 01 44 37)") # begin reverse video
    export LESS_TERMCAP_se=$(echo -e "$(get_color_end -)")      # reset reverse video
    export LESS_TERMCAP_us=$(echo -e "$(get_color - 04 01 32)") # begin underline
    export LESS_TERMCAP_ue=$(echo -e "$(get_color_end -)")      # reset underline

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
