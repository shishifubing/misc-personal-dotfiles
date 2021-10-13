#!/usr/bin/env bash

convert_plural() {

    if [[ "${1}" -gt 1 ]]; then
        local result="${1} ${4:-"${2}s"}"
    elif [[ "${1}" -eq 1 ]]; then
        local result="${1} ${5:-"${3}"}"
    else
        local result=
    fi

    echo "${result}"

}

# convert seconds into days+hours+minutes+seconds
convert_time() {

    local input="${1/.*/}"
    local fraction="${1/*./}"
    local seconds minutes hours days

    if ((input > 59)); then
        seconds=$((input % 60))
        minutes=$((input / 60))
        if ((minutes > 59)); then
            minutes=$((minutes % 60))
            hours=$((input / 60))
        else
            minutes="${input}"
        fi
    else
        seconds="${input}"
    fi

    [[ "${hours}" ]] || hours=0
    [[ "${minutes}" ]] || minutes=0

    echo "${hours}:${minutes}:${seconds}:${fraction}"

}
