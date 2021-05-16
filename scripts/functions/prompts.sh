#!/usr/bin/env bash

# prompts

# preexec message
get_preexec_message() {

    local output message=$(date +"[%A] [%B] [%Y-%m-%d] [%H:%M:%S:${TRAP_DEBUG_TIME_START/*./}]")

    #output+="${GC_32}] ${GC_END}"
    #output+="${GC_30}$(get_shell_separator_line ☰)${GC_END}\n"
    output+="${GC_32}] ${GC_END}${GC_33}${message}${GC_END}${GC_32} [${GC_37}\n"

    echo "${output}"

}

# precmd message
get_precmd_message() {

    local output message=$(date +"[%A] [%B] [%Y-%m-%d] [%H:%M:%S:${TRAP_DEBUG_TIME_END/*./}]")

    #output+="\n"
    output+="\n${GC_32}] ${GC_33}${message}${GC_END}\n"
    output+="${GC_30}$(get_shell_separator_line ☰)${GC_END}"

    echo "${output}"

}

# generate the PS1 prompt
get_shell_prompt_PS1() {

    local output
    local time_elapsed=$(bc <<<"${TRAP_DEBUG_TIME_END}-${TRAP_DEBUG_TIME_START}")
    local time_elapsed=$(convert_time "$(printf "%.6f" "${time_elapsed}")")
    local git_branch=$(get_current_branch)

    local time_elapsed="${GC_33_}[${time_elapsed}]${GC_END_} "
    [[ "${ENVIRONMENT}" ]] && local environment="${GC_31_}[${ENVIRONMENT}]${GC_END_} "
    local user="${GC_37_}[\u] [\H] ${GC_END_}"
    local shell="${GC_36_}[\s_\V] [\l:\j] ${GC_END_}"
    local directory="${GC_34_}[\w] ${GC_END_}"
    [[ "${git_branch}" ]] && local git_branch="${GC_35_}[${git_branch}] ${GC_END_}"
    local user_sign="${GC_32_}[\$] [${GC_END_}"

    output+="┌${GC_1_5_}┐ ${user}${shell}${environment}\n"
    output+="│${GC_6_10_}│ ${directory}${git_branch}\n"
    output+="└${GC_11_15_}┘ ${time_elapsed}\n"
    output+="${user_sign}\n"
    output+="    ${GC_37_}"

    echo "${output}"
}

# shell command separator
get_shell_separator_line() {

    local output line_length=$((${3:-"$(get_terminal_width)"} - ${2:-"0"}))
    local separator=${1:-"─"}

    for ((count = 0; count < line_length; count++)); do
        output+="${separator}"
    done

    echo "${output}"

}
