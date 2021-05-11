#!/usr/bin/env bash

# prompts

# preexec message
get_preexec_message() {

    local message=$(date +"[%A] [%B] [%Y-%m-%d] [%H:%M:%S:${TRAP_DEBUG_TIME_START/*./}]")
    local separator=$(get_shell_separator_line 0 ▽)

    echo "$(get_color 32)}"
    echo "$(get_color 30)${separator}$(get_color_end)"
    echo "$(get_color 33)${message}$(get_color_end)"
    get_color 37

}

# precmd message
get_precmd_message() {

    local message=$(date +"[%A] [%B] [%Y-%m-%d] [%H:%M:%S:${TRAP_DEBUG_TIME_END/*./}]")
    local separator=$(get_shell_separator_line 0 △)

    echo
    echo "$(get_color 33)${message}$(get_color_end)"
    echo "$(get_color 30)${separator}$(get_color_end)"

}

# generate the PS1 prompt
get_shell_prompt_PS1() {

    local gc_30=$(get_color - 30)
    local gc_31=$(get_color - 31)
    local gc_32=$(get_color - 32)
    local gc_33=$(get_color - 33)
    local gc_34=$(get_color - 34)
    local gc_35=$(get_color - 35)
    local gc_36=$(get_color - 36)
    local gc_37=$(get_color - 37)
    local gc_end=$(get_color_end -)
    local gc_1_5=$(get_terminal_colors 1 5)
    local gc_6_10=$(get_terminal_colors 6 10)
    local gc_11_15=$(get_terminal_colors 11 15)
    local time_difference=$(bc <<<"${TRAP_DEBUG_TIME_END}-${TRAP_DEBUG_TIME_START}")
    local time_readable=$(convert_time "$(printf "%.6f" "${time_difference}")")

    local time_elapsed="${gc_33}[${time_readable}] "
    [[ -z "${ENVIRONMENT}" ]] || local environment="${gc_31}[${ENVIRONMENT}] "
    local user="${gc_37}[\u] [\H] "
    local shell="${gc_36}[\s_\V] [\l:\j] "
    local directory="${gc_34}[\w] "
    [[ -z "$(get_current_branch)" ]] || local git_branch="${gc_35}[$(get_current_branch)] "
    local user_sign="${gc_32}[\$]${gc_37} => ${gc_32}{"

    echo "${gc_1_5} ${user}${shell}${environment}${gc_end}"
    echo "${gc_6_10} ${directory}${git_branch}${gc_end}"
    echo "${gc_11_15} ${time_elapsed}${gc_end}"
    echo "${user_sign}${gc_end}"
    echo "    ${gc_37}"
}

# shell command separator
get_shell_separator_line() {

    local line_length=$(get_terminal_width)
    local line_length=$((${3:-${line_length}} - ${1:-"0"}))
    local separator=${2:-"─"}
    eval printf -- "${separator}%.s" "{1..${line_length}}"
    # eval is needed since brace expansion precedes parameter expansion
    # double '-' since printf needs options
}
