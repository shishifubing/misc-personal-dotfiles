#!/usr/bin/env bash

# prompts

# generate the PS0 prompt
get_shell_prompt_PS0() {

    local message="$(date +"[%A] [%B] [%Y-%m-%d] [%H:%M:%S:${TRAP_DEBUG_TIME_START/*./}]")\n"
    local separator_middle="$(get_color - 30)$(get_shell_separator_line 0 ▲)$(get_color - 37)"
    set_window_title "$(get_directory)"

    echo "${separator_middle}"
    echo "${message}"

}

# generate the PS1 prompt
get_shell_prompt_PS1() {

    local gc_30=$(get_color 30)
    local gc_31=$(get_color 31)
    local gc_32=$(get_color 32)
    #local gc_33=$(get_color 33)
    local gc_34=$(get_color 34)
    local gc_35=$(get_color 35)
    local gc_36=$(get_color 36)
    local gc_37=$(get_color 37)
    local gc_end=$(get_color_end)
    local time_elapsed=$(bc <<<"${TRAP_DEBUG_TIME_END}-${TRAP_DEBUG_TIME_START}")
    local time_elapsed=$(convert_time "$(printf "%.6f" "${time_elapsed}")")

    local time_elapsed="${gc_32}[${time_elapsed}]"
    local time_end="${gc_37}$(date +"[%A] [%B] [%Y-%m-%d] [%H:%M:%S:${TRAP_DEBUG_TIME_END/*./}]")"
    #local separator_top="${gc_30}$(get_shell_separator_line 0 -)${gc_37}"
    local separator_bot="${gc_30}$(get_shell_separator_line 0 ▼)${gc_37}"
    [[ -z "${ENVIRONMENT}" ]] || local environment="${gc_31}[${ENVIRONMENT}] "
    local user="${gc_37}[\u \H] "
    local shell="${gc_36}[\s_\V \l:\j] "
    local directory="${gc_34}[\w] "
    [[ -z "$(get_current_branch)" ]] || local git_branch="${gc_35}[$(get_current_branch)] "
    #local user_sign="${gc_37}\$ "
    local colors_1="$(get_colors 0 2 1 -) "
    local colors_2="$(get_colors 3 5 - 0) "
    local colors_3="$(get_colors 5 7 1 -) "

    echo
    echo "${time_end}${gc_end}"
    echo "${separator_bot}${gc_end}"
    echo "${colors_1}${user}${shell}${environment}${gc_end}"
    echo "${colors_2}${directory}${git_branch}${gc_end}"
    echo "${colors_3}${time_elapsed}${gc_end}"
    echo #"${separator_top}${gc_end}"
    echo "${gc_37}"
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
