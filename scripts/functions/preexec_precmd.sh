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
    unset TRAP_DEBUG_TIME_START TRAP_DEBUG_TIME_END

}

# before all commands
preexec() {

    start_time="$(date "+%s.%N")"
    export TRAP_DEBUG_TIME_START="${start_time::-3}"
    #set_window_title "$(get_directory)■$(history -w /dev/stdout 1)"
    if [[ "${HIDE_PREEXEC_MESSAGE}" ]]; then
        unset HIDE_PREEXEC_MESSAGE
    else
	echo -e "$(get_preexec_message)"
    fi

}

# before the prompt
precmd() {

    end_time="$(date +"%s.%N")"
    export TRAP_DEBUG_TIME_END="${end_time::-3}"
    echo -e "$(get_precmd_message)"
    echo -e "$(get_shell_prompt_PS1)"
    unset TRAP_DEBUG_TIME_START
}
