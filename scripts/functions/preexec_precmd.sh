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

    TRAP_DEBUG_TIME_START=$(date +"%s.%N")
    #set_window_title "$(get_directory)■$(history -w /dev/stdout 1)"
    [[ "${HIDE_PREEXEC_MESSAGE}" ]] || echo -e "$(get_preexec_message)"

    export TRAP_DEBUG_TIME_START
    unset HIDE_PREEXEC_MESSAGE
}

# before the prompt
precmd() {

    TRAP_DEBUG_TIME_END=$(date +"%s.%N")
    PS1=
    echo -e "$(get_precmd_message)"
    echo -e "$(get_shell_prompt_PS1)"

    export PS1 TRAP_DEBUG_TIME_END
    unset TRAP_DEBUG_TIME_START TRAP_DEBUG_TIME_END
}
