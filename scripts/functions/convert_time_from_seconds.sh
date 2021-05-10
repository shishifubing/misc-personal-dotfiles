#!/usr/bin/env bash

# convert seconds into days+hours+minutes+seconds
convert_time() {

    local input=${1/.*/}
    local fraction=${1/*./}
    local seconds minutes hours days

    if ((input > 59)); then
        ((seconds = input % 60))
        ((input = input / 60))
        if ((input > 59)); then
            ((minutes = input % 60))
            ((input = input / 60))
            if ((input > 23)); then
                ((hours = input % 24))
                ((days = input / 24))
            else
                ((hours = input))
            fi
        else
            ((minutes = input))
        fi
    else
        ((seconds = input))
    fi

    [[ -z "${days}" ]] || days="${days} day(s) "
    [[ -z "${hours}" ]] || hours="${hours} hour(s) "
    [[ -z "${minutes}" ]] || minutes="${minutes} minute(s) "
    seconds="${seconds}.${fraction} seconds"

    echo "${days}${hours}${minutes}${seconds}"

}
