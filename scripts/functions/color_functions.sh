#!/usr/bin/env bash

# color functions

# get color code
get_color() {

    # text format, does not affect background
    #   0 - normal, 1 - bold, 4 - underlined,
    #   5 - blinking, 7 - reverse video
    # terminal color numbers
    #   foreground: 30 - 37; background: 40 - 47
    case "${1}" in
    "-") shift && echo "\[\e[${2:-1};${1:-37};${3:-40}m" ;;
    *) echo "\e[${2:-1};${1:-37};${3:-40}m" ;;
    esac

}

# reset color modifications
get_color_end() {

    case "${1}" in
    "-") echo "\e[0m\]" ;;
    *) echo "\e[0m" ;;
    esac

}

# get terminal colors
get_terminal_colors() {

    # the range of colors to print
    block_range=("${1:-0}" "${2:-15}")
    # color block width in spaces
    local blocks block_width
    # convert the width to space chars
    printf -v block_width "%${3:-2}s"

    # generate the string
    for ((block_range[0]; block_range[0] <= block_range[1]; block_range[0]++)); do
        blocks+="$(get_color 5 48 "${block_range[0]}")${block_width}"
    done

    echo "${blocks}$(get_color_end)"

}
