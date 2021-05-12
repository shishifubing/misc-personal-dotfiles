#!/usr/bin/env bash

# prompts

# preexec message
get_preexec_message() {

    local message=$(date +"[%A] [%B] [%Y-%m-%d] [%H:%M:%S:${TRAP_DEBUG_TIME_START/*./}]")
    local separator=$(get_shell_separator_line ▽)

    echo "${GC_32}}"
    echo "${GC_30}${separator}${GC_END}"
    echo "${GC_33}${message}${GC_END}"
    echo "${GC_37}"

}

# precmd message
get_precmd_message() {

    local message=$(date +"[%A] [%B] [%Y-%m-%d] [%H:%M:%S:${TRAP_DEBUG_TIME_END/*./}]")
    local separator=$(get_shell_separator_line △)

    echo
    echo "${GC_33}${message}${GC_END}"
    echo "${GC_30}${separator}${GC_END}"

}

# generate the PS1 prompt
get_shell_prompt_PS1() {

    local time_elapsed=$(bc <<<"${TRAP_DEBUG_TIME_END}-${TRAP_DEBUG_TIME_START}")
    local time_elapsed=$(convert_time "$(printf "%.6f" "${time_elapsed}")")
    local git_branch=$(get_current_branch)

    local time_elapsed="${GC_33_}[${time_elapsed}]${GC_END_} "
    [[ -z "${ENVIRONMENT}" ]] || local environment="${GC_31_}[${ENVIRONMENT}]${GC_END_} "
    local user="${GC_37_}[\u] [\H] ${GC_END_}"
    local shell="${GC_36_}[\s_\V] [\l:\j] ${GC_END_}"
    local directory="${GC_34_}[\w] ${GC_END_}"
    [[ -z "${git_branch}" ]] || local git_branch="${GC_35_}[${git_branch}] ${GC_END_}"
    local user_sign="${GC_32_}[\$] {${GC_END_}"

    echo "${GC_1_5_} ${user}${shell}${environment}"
    echo "${GC_6_10_} ${directory}${git_branch}"
    echo "${GC_11_15_} ${time_elapsed}"
    echo "${user_sign}"
    echo "    ${GC_37_}"
}

# shell command separator
get_shell_separator_line() {

    local line_length=$((${3:-"$(get_terminal_width)"} - ${2:-"0"}))
    local separator=${1:-"─"}
    for ((count = 0; count < line_length; count++)); do echo -n "${separator}"; done
}
