#!/usr/bin/env bash

# color functions

# wrap in color
color_wrap() {

    echo "$(color_get "${2}")${1}${GC_END}"
}
color_wrap_() {

    echo "$(color_get_ "${2}")${1}${GC_END_}"
}

# get color code
color_get() {

    # text format, does not affect background
    #   0 - normal, 1 - bold, 4 - underlined,
    #   5 - blinking, 7 - reverse video
    # terminal color numbers
    #   foreground: 30 - 37; background: 40 - 47
    echo "\e[${1}m"

}

color_get_() {

    echo "\[\e[${1}m"

}
color_end() {

    echo "\e[0m"

}

color_end_() {

    echo "\e[0m\]"

}

# get terminal colors
color_colors() {

    if [[ "${1}" == '-b' ]]; then
        wrap="color_wrap_"
	shift
    else
	wrap="color_wrap"
    fi

    # the range of colors to print
    local block_range=("${1:-0}" "${2:-15}")
    # color block width in spaces
    local output
    local block_width=$(printf "%${3:-2}s")

    # generate the string
    for ((block_range[0]; block_range[0] <= block_range[1]; block_range[0]++)); do
        output+="$(${wrap} "${block_range[0]}" "5;48")${block_width}"
    done

    echo "${output}${GC_END}"

}

# print colors
color_colors_print() {

    echo -e "${GC_0_15}"

}

# brackets are needed for prompts
# but other times they might be  displayed
color_remove_brackets() {

    local output="${1//"\["/}"

    echo "${output//"\]"/}"

}
