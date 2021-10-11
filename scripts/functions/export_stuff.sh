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

    for folder in "${DOTFILES}/binaries"/*; do
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

    for folder in "${DOTFILES}/binaries"/*; do
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

    export GC_30="$(color_get "1;30")"
    export GC_030="$(color_get "0;30")"
    
    export GC_31="$(color_get "1;31")"
    export GC_031="$(color_get "0;31")"
    
    export GC_32="$(color_get "1;32")"
    export GC_032="$(color_get "0;32")"
    
    export GC_33="$(color_get "1;33")"
    export GC_033="$(color_get "0;33")"
    
    export GC_34="$(color_get "1;34")"
    export GC_034="$(color_get "0;34")"
    
    export GC_35="$(color_get "1;35")"
    export GC_035="$(color_get "0;35")"
    
    export GC_36="$(color_get "1;36")"
    export GC_036="$(color_get "0;36")"
    
    export GC_37="$(color_get "1;37")"
    export GC_037="$(color_get "0;37")"
    
    export GC_END=$(color_end)

}

# other variables
export_variables_others() {

    ## dot files
    export DOTFILES="${HOME}/dotfiles"
    ## tty name
    export TTY_NAME="$(tty)"
    ## location of dot-files
    export DOT_FILES="${HOME}/dot-files"
    ## prompt variable that is shown when there are multiple lines
    #export PS2="${GC_32_}▶${GC_END_}"
    export PS2=
    ## the main prompt variable
    export PS1=
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
