#!/usr/bin/env bash

# color functions

# get color code
get_color() {

    # text format, does not affect background
    #   0 - normal, 1 - bold, 4 - underlined,
    #   5 - blinking, 7 - reverse video
    # terminal color numbers
    #   foreground: 30 - 37; background: 40 - 47
    [[ "${1}" == "-b" ]] && local with_brackets=true && shift
    local input=("${@}") length="${#}" output="\[\e[${1}"

    for ((argument = 1; argument < length; argument++)); do
        output+=";${input[${argument}]}"
    done
    output+="m"
    [[ "${with_brackets}" ]] || output=$(remove_brackets "${output}")

    echo "${output}"

}

# reset color modifications
get_color_end() {

    local output="\e[0m\]"
    [[ "${1}" == "-b" ]] || output=$(remove_brackets "${output}")

    echo "${output}"

}

# get terminal colors
get_colors() {

    [[ "${1}" == "-b" ]] && local with_brackets=true && shift
    # the range of colors to print
    local block_range=("${1:-0}" "${2:-15}")
    # color block width in spaces
    local output block_width=$(printf "%${3:-2}s")

    # generate the string
    for ((block_range[0]; block_range[0] <= block_range[1]; block_range[0]++)); do
        output+="$(get_color "48" "5" "${block_range[0]}")${block_width}"
    done
    output+="${GC_END}"
    [[ "${with_brackets}" ]] || output=$(remove_brackets "${output}")

    echo "${output}"

}

# brackets are needed for prompts
# but other times they might be  displayed
remove_brackets() {

    local output="${1//"\["/}" && echo "${output//"\]"/}"

}
