#!/usr/bin/env bash

# characters
symbols() {

    S_HORIZONTAL="─"
    S_VERTICAL="│"
    S_TOP_LEFT="┌"
    S_TOP_RIGHT="┐"
    S_BOTTOM_LEFT="└"
    S_BOTTOM_RIGHT="┘"
    S_TOP_MIDDLE="┰"

}

# declared functions
export_declared_functions() {

    mapfile -t "functions" <<<"$(get_declared_functions)"
    export -f "${functions[@]}"

}

# export binaries
export_binaries_all() {

    for folder in "${HOME}/dot-files/binaries"/*; do
        local binaries=$(find_binaries "${folder}")
        if [[ "${binaries}" ]]; then
            #array_command "sudo chmod +x" "${binaries[@]}"
            local binaries_directories=$(array_command dirname "${binaries[@]}")
            local binaries_path=$(array_join ':' "${binaries_directories[@]}")
	    array_in "${binaries_path}" "${PATH}" ||  
	        export PATH="${PATH}:${binaries_path}"
	    
        fi
    done

}

export_binaries() {

    for folder in "${HOME}/dot-files/binaries"/*; do
	array_in "${folder}" "${PATH}" || 
	        export PATH="${PATH}:${folder}"
        [[ -d "${folder}/bin" ]] && array_in "${folder}/bin" "${PATH}" || 
	        export PATH="${PATH}:${folder}/bin"
    done

}

# less variables
# https://www.topbug.net/blog/2016/09/27/make-gnu-less-more-powerful/
export_variables_less() {

    # --quit-if-one-screen --ignore-case --status-column --LONG-PROMPT
    # --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4
    local reset="$(echo -e "${GC_END}")"
    local bold="$(echo -e "${GC_31}")"
    local blink="$(echo -e "${GC_34}")"
    local underline="$(echo -e "$(color_get 04 01 32)")"
    local reverse_video="$(echo -e "$(color_get 01 44 37)")"

    export LESS="-F -i -J -M -R -W -x4 -X -z-4"
    export LESS_TERMCAP_mb="${bold}"          # begin bold
    export LESS_TERMCAP_md="${blink}"         # begin blink
    export LESS_TERMCAP_me="${reset}"         # reset bold/blink
    export LESS_TERMCAP_so="${reverse_video}" # begin reverse video
    export LESS_TERMCAP_se="${reset}"         # reset reverse video
    export LESS_TERMCAP_us="${underline}"     # begin underline
    export LESS_TERMCAP_ue="${reset}"         # reset underline

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
        eval 'export GC_3${count}=$(color_get "1;3${count}")'
	eval 'export GC_3${count}_=$(color_get_ "1;3${count}")'
        eval 'export GC_03${count}=$(color_get "0;3${count}")'
        eval 'export GC_03${count}_=$(color_get_ "0;3${count}")'
        
	eval 'export GC_4${count}=$(color_get "1;4${count}")'
        eval 'export GC_4${count}_=$(color_get_ "1;4${count}")'
        eval 'export GC_04${count}=$(color_get "0;4${count}")'
        eval 'export GC_04${count}_=$(color_get_ "0;4${count}")'
    done

    export GC_END=$(color_end) GC_END_=$(color_end_)

    #export GC_0_3=$(color_colors 0 3) GC_0_3_=$(color_colors -b 0 3)
    #export GC_4_7=$(color_colors 4 7) GC_4_7_=$(color_colors -b 4 7)
    #export GC_8_11=$(color_colors 8 11) GC_8_11_=$(color__colors 8 11)
    #export GC_12_15=$(color_colors 12 15) GC_12_15_=$(color_colors 12 15)
    #export GC_0_15=$(color_colors 0 15) GC_0_15_=$(color_colors 0 15)
    
    #export GC_1_5=$(color_colors 1 5) GC_1_5_=$(color_colors 1 5)
    #export GC_6_10=$(color_colors 6 10) GC_6_10_=$(color_colors 6 10)
    #export GC_11_15=$(color_colors 11 15) GC_11_15_=$(color_colors 11 15)
}

# other variables
export_variables_others() {

    ## tty name
    export TTY_NAME="$(tty)"
    ## location of dot-files
    export DOT_FILES="${HOME}/dot-files"
    ## when multiple lines
    #export PS2="${GC_32_}▶${GC_END_}"
    export PS2="  "
    ## all locales are overwritten
    export LC_ALL="en_US.UTF-8"
    export LANG="en_US.UTF-8"
    ## colored GCC warnings and errors
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
    ## path edit for ruby gems to work
    #export PATH="${PATH}:${HOME}/.local/share/gem/ruby/3.0.0/bin"
    ## path edit for local binaries
    #export PATH="${PATH}:${HOME}/.local/bin"
    ## fzf
    export FZF_DEFAULT_OPTS="--height=50% --layout=reverse --border=none --margin=0 --padding=0"
    ## silences npm funding messages
    export OPEN_SOURCE_CONTRIBUTOR=true

}
