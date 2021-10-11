#!/usr/bin/env bash

# prompts

calculate_bash_command() {

    local bash_command=$(
        history -w /dev/stdout |
            tail -n 1
    )
    echo "$(("${#bash_command}" + 2))"

}

# after prompt
get_preexec_message() {

    local date=$(date "+%H:%M:%S:${TRAP_DEBUG_TIME_START/*./}")
    local start_time=(
        $(prompt_rectangle "${date}" "${GC_33}")
    )
    
    local output=(
        "${start_time[0]}"
        "${start_time[1]}"
        "${start_time[2]}"
    )
    
    echo "$(array_join $'\n' "${output[@]}")"

}

# before prompt
get_precmd_message() {

    local time_elapsed="${TRAP_DEBUG_TIME_END} - ${TRAP_DEBUG_TIME_START}"
    local time_elapsed="$(printf "%.6f" "$(bc <<<"${time_elapsed}")")"
    local time_elapsed=$(convert_time "${time_elapsed}")
    local date=$(date "+%H:%M:%S:${TRAP_DEBUG_TIME_END/*./}")
    
    local end_time=(
        $(prompt_rectangle "${date}" "${GC_33}")
    )
    local time_elapsed=(
        $(prompt_rectangle "${time_elapsed}" "${GC_33}")
    )

    local output=(
        "${end_time[0]} ${time_elapsed[0]}"
        "${end_time[1]} ${time_elapsed[1]}"
        "${end_time[2]} ${time_elapsed[2]}"
    )

    echo "$(array_join $'\n' "${output[@]}")"

}

# wrap prompt element
wrap_prompt_element() {

    local color_wrapper="${3:-"${GC_37}"}"
    local color_element="${4:-"${GC_37}"}"
    local middle="${color_wrapper}$(repeat_string "${#1}")${GC_END}"
    symbols

    case "${2-"middle"}" in
        "top") 
	    local left="${S_TOP_LEFT}"
	    local right="${S_TOP_RIGHT}"
	    ;;
	"bottom") 
	    local left="${S_BOTTOM_LEFT}"
	    local right="${S_BOTTOM_RIGHT}"
	    ;;
        *) 
	    local left="${S_VERTICAL}"
	    local right="${S_VERTICAL}"
            local middle="${color_element}${1}${GC_END}"
	    ;;
    esac

    local left="${color_wrapper}${left}${GC_END}"
    local right="${color_wrapper}${right}${GC_END}"
    
    echo "${left}${middle}${right}"

}

# get rectangle
prompt_rectangle() {

    local output=(   
        "$(wrap_prompt_element "${1}" top "${2}")"
        "$(wrap_prompt_element "${1}" middle "${2}")"
        "$(wrap_prompt_element "${1}" bottom "${2}")"
    ) 

    echo "${output[@]}"

}


# generate the PS1 prompt
get_shell_prompt_PS1() {

    local git_branch="$(get_current_branch)"
    local git_branch=(
        $(prompt_rectangle "${git_branch:-none}" "${GC_34}")
    )
    local current_directory=(
        $(prompt_rectangle "${PWD}" "${GC_34}")
    )
    local hostname=(
        $(prompt_rectangle "${HOSTNAME}" "${GC_35}")
    )
    local user=(
        $(prompt_rectangle "${USER}" "${GC_36}")
    )
    local bash_version=(
        $(prompt_rectangle "${BASH_VERSION}" "${GC_037}")
    )
    local current_tty=(
        $(prompt_rectangle "${TTY_NAME//[!0-9]/}" "${GC_37}")
    )
    local jobs_r=(
        $(prompt_rectangle "$(jobs -r | wc -l)" "${GC_32}")
    )
    local jobs_s=(
        $(prompt_rectangle "$(jobs -s | wc -l)" "${GC_31}")
    )

    local jobs_top="${current_tty[0]} ${jobs_r[0]} ${jobs_s[0]}"
    local jobs_middle="${current_tty[1]} ${jobs_r[1]} ${jobs_s[1]}"
    local jobs_bottom="${current_tty[2]} ${jobs_r[2]} ${jobs_s[2]}"

    local output=(
        "${user[0]} ${hostname[0]} ${bash_version[0]}"
	"${user[1]} ${hostname[1]} ${bash_version[1]}"
	"${user[2]} ${hostname[2]} ${bash_version[2]}"

        "${git_branch[0]} ${current_directory[0]} ${jobs_top}"
        "${git_branch[1]} ${current_directory[1]} ${jobs_middle}"
        "${git_branch[2]} ${current_directory[2]} ${jobs_bottom}"
    )
    
    echo "\n$(array_join $'\n' "${output[@]}")"

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
