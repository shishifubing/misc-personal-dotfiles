#!/usr/bin/env bash

# executed before all commands and before the prompt
# preexec.sh does the same but it is overkill

# enable it
start_preexec_precmd() {

    # trap DEBUG is executed before each command
    # even if they are written on the same line
    # including PROMPT_COMMAND
    trap '[[ -z "${TRAP_DEBUG_TIME_START}" ]] && preexec' DEBUG
    # PROMPT_COMMAND is executed before each prompt
    export PROMPT_COMMAND='precmd'

}

# before all commands
preexec() {
    export TRAP_DEBUG_TIME_START=$(date +"%s.%N")
    #set_window_title "$(get_directory)■$(history -w /dev/stdout 1)"
    [[ -z "${__is_first_launch}" ]] && {
        echo -e "$(get_color 32){\n$(get_color 37)    start"
        __is_first_launch=0
    }
    echo -e "$(get_preexec_message)"

}

# before the prompt
precmd() {

    export TRAP_DEBUG_TIME_END=$(date +"%s.%N")
    export PS1=$(get_shell_prompt_PS1)
    echo -e "$(get_precmd_message)"

    unset TRAP_DEBUG_TIME_START TRAP_DEBUG_TIME_END
}
