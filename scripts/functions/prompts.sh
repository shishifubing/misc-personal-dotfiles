#!/usr/bin/env bash

# prompts

calculate_bash_command() {

    local bash_command=$(
        history -w /dev/stdout |
            tail -n 1
    )
    echo "$(("${#bash_command}" + 2))"

}

# preexec message
get_preexec_message() {

    local start=${TRAP_DEBUG_TIME_START/*./}
    local message="%H:%M:%S:${start}"
    local output=(
        "${GC_34}start${GC_END}: $(date +"${message}")${GC_END}"
        "${GC_34}output${GC_END}: "
    )
    
    echo "$(array_join $'\n' "${output[@]}")"

}

# precmd message
get_precmd_message() {

    local start="${TRAP_DEBUG_TIME_START}"
    local end="${TRAP_DEBUG_TIME_END}"
    local time_elapsed=$(bc <<<"${end}-${start}")
    local time_elapsed=$(printf "%.6f" "${time_elapsed}")
    local message="%H:%M:%S:${end/*./}"
    

    local output=(
        "${GC_34}end${GC_END}: $(date +"${message}")${GC_END}"
        "${GC_34}elapsed time${GC_END}: $(convert_time "${time_elapsed}")${GC_END}"
    )

    echo "$(array_join $'\n' "${output[@]}")"

}

# wrap prompt element
wrap_prompt_element() {

    [[ "${1}" == "-m" ]] && {
        local no_modify_middle="true"
        shift
    }
    local element="${1}"
    local element_visible=$(echo -e "${element}")
    local separator="$(repeat_string "${#element_visible}")"
    local type="${2:-"middle"}"
    local color_wrapper="${3:-37}"
    local color_element="${4:-${3}}"
    local middle="${element}"
    
    case "${type}" in
        "top") 
	    local left=$(color_wrap -b "┌" "${3}")
	    local right=$(color_wrap -b "┐" "${3}")
            [[ "${no_modify_middle}" ]] ||
	        local middle=$(color_wrap -b "${separator}" "${4}")
		;;
	"bot") 
	    local left=$(color_wrap -b "└" "${3}")
	    local right=$(color_wrap -b "┘" "${3}")
            [[ "${no_modify_middle}" ]] ||
                local middle=$(color_wrap -b "${separator}" "${4}")
	        ;;
	*) 
	    local left=$(color_wrap "│" "${3}")
	    local right=$(color_wrap "│" "${3}")
            [[ "${no_modify_middle}" ]] ||
                local middle=$(color_wrap -b "${element}" "${4}")
		;;
    esac

    echo "${left}${middle}${right}"

}

# generate the PS1 prompt
get_shell_prompt_PS1() {

    local git=$(get_current_branch)
    local jobs_run=$(jobs -r | wc -l)
    local jobs_stop=$(jobs -s | wc -l)
    local jobs="${jobs_run} ${jobs_stop}" 

    local user_info="${USER} ${HOSTNAME}${GC_END_}"
    local directory_info="${git:-"none"} ${PWD}${GC_END_}"
    local bash_info="${BASH_VERSION} $(tty) ${jobs}${GC_END_}"

    local output=(
        "${GC_34_}user${GC_END_}: ${user_info}"
        "${GC_34_}bash${GC_END_}: ${bash_info}"
        "${GC_34_}directory${GC_END_}: ${directory_info}"        
        "${GC_34_}command${GC_END_}: ${GC_END_}"
    )

    echo "\n$(array_join $'\n' "${output[@]}")\\]"
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
