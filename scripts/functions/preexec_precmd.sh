#!/usr/bin/env bash

# executed before all commands and before the prompt
# preexec.sh does the same but it is overkill

# enable it
start_preexec_precmd() {

    # trap DEBUG is executed before each command
    # even if they are written on the same line
    # including PROMPT_COMMAND
    trap '[[ "${TRAP_DEBUG_TIME_START}" ]] || preexec' DEBUG
    # PROMPT_COMMAND is executed before each prompt
    export PROMPT_COMMAND='precmd'
    export HIDE_PREEXEC_MESSAGE='True'

}

# before all commands
preexec() {

    export TRAP_DEBUG_TIME_START="$(date +"%s.%N")"
    #set_window_title "$(get_directory)■$(history -w /dev/stdout 1)"
    if [[ "${HIDE_PREEXEC_MESSAGE}" ]]; then
        export HIDE_PREEXEC_MESSAGE=
    else
	echo -e "$(get_preexec_message)"
    fi

}

# before the prompt
precmd() {

    export TRAP_DEBUG_TIME_END="$(date +"%s.%N")"
    echo -e "$(get_precmd_message)"
    echo -e "$(get_shell_prompt_PS1)"
    export TRAP_DEBUG_TIME_START=
}
