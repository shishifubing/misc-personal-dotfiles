#!/usr/bin/env bash

# color functions

# wrap in color
color_wrap() {

    [[ "${1}" == "-b" ]] && local toggle_bracket="-b" && shift
    local target="${1}"
    shift
    local color="${2:-37}"
    shift

    local color_start="$(get_color "${toggle_bracket}" "${color}" "${@}")"
    local color_end="$(get_color_end "${toggle_bracket}")"

    echo "${color_start}${target}${color_end}"

}

# get color code
get_color() {

    # text format, does not affect background
    #   0 - normal, 1 - bold, 4 - underlined,
    #   5 - blinking, 7 - reverse video
    # terminal color numbers
    #   foreground: 30 - 37; background: 40 - 47
    [[ "${1}" == "-b" ]] && {
        local with_brackets=true
        shift
    }
    local input=("${@}")
    local length="${#}"
    local output="\[\e[${1}"

    for ((count = 1; count < length; count++)); do
        output+=";${input[${count}]}"
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

    [[ "${1}" == "-b" ]] && {
        local with_brackets=true
        shift
    }
    # the range of colors to print
    local block_range=("${1:-0}" "${2:-15}")
    # color block width in spaces
    local output
    local block_width=$(printf "%${3:-2}s")

    # generate the string
    for ((block_range[0]; block_range[0] <= block_range[1]; block_range[0]++)); do
        output+="$(get_color "48" "5" "${block_range[0]}")${block_width}"
    done
    output+="${GC_END}"
    [[ "${with_brackets}" ]] || output=$(remove_brackets "${output}")

    echo "${output}"

}

# print colors
print_colors() {

    echo -e "${GC_0_15}"

}

# brackets are needed for prompts
# but other times they might be  displayed
remove_brackets() {

    local output="${1//"\["/}"
    output="${output//"\]"/}"

    echo "${output}"

}
