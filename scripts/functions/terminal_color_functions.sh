#!/usr/bin/env bash

# color functions

# get color code
get_color() {

    # text format, does not affect background
    #   0 - normal, 1 - bold, 4 - underlined,
    #   5 - blinking, 7 - reverse video
    # terminal color numbers
    #   foreground: 30 - 37; background: 40 - 47
    [[ "${1}" == "-" ]] && local bracket="\e" && shift
    echo "${bracket:-\[\e}[${2:-1};${1:-37};${3:-40}m"

}

# return end of color modification
get_color_end() {

    [[ "${1}" == "-" ]] && local bracket="m"
    echo "\e[0${bracket:-\]m}"

}

# get terminal colors
get_colors() {

    local start=${1:-"0"}
    local end=${2:-"7"}
    local type_start=${3:-"-"} # print at the beginnning
    local type_end=${4:-"-"}   # print at the end

    output() {
        local number=${1:-"0"}
        local type=${2:-"0"}
        local color=$(get_color "$((number + 30))" "${type}" "$((number + 40))")
        echo "${color}██$(get_color_end)"
    }
    for ((color = start; color <= end; color++)); do
        if [[ "${color}" == "${start}" && "${type_start}" != "-" ]]; then
            echo -n "$(output "${color}" "${type_start}")"
        elif [[ "${color}" == "${end}" && "${type_end}" != "-" ]]; then
            echo -n "$(output "${color}" "${type_end}")"
        else
            echo -n "$(output "${color}" "0")$(output "${color}" "1")"
        fi
    done

}
