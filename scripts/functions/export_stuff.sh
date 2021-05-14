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
    local reset=$(echo -e "${GC_END}")
    local bold=$(echo -e "${GC_31}")
    local blink=$(echo -e "${GC_34}")
    local underline=$(echo -e "$(get_color 04 01 32)")
    local reverse_video=$(echo -e "$(get_color 01 44 37)")

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

# colors
export_variables_colors() {

    for ((count = 0; count < 8; count++)); do
        eval 'export GC_3${count}=$(get_color 01 3${count})'
        eval 'export GC_3${count}_=$(get_color -b 01 3${count} 01)'
    done

    export GC_END=$(get_color_end) GC_END_=$(get_color_end -b)

    export GC_1_5=$(get_colors 1 5) GC_1_5_=$(get_colors -b 1 5)
    export GC_6_10=$(get_colors 6 10) GC_6_10_=$(get_colors -b 6 10)
    export GC_11_15=$(get_colors 11 15) GC_11_15_=$(get_colors -b 11 15)
}

# other variables
export_variables_others() {

    # when multiple lines
    export PS2="${GC_32_}▶   ${GC_37_}"
    # all locales are overwritten
    export LC_ALL="en_US.UTF-8"
    # colored GCC warnings and errors
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
    # path edit for ruby gems to work
    export PATH="${PATH}:${HOME}/.local/share/gem/ruby/3.0.0/bin"
    # path edit for local binaries
    export PATH="${PATH}:${HOME}/.local/bin"
    # fzf
    export FZF_DEFAULT_OPTS="--height=50% --layout=reverse --border=none --margin=0 --padding=0"
    # silences npm funding messages
    export OPEN_SOURCE_CONTRIBUTOR=true

}
