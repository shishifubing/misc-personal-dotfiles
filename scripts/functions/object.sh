#!/usr/bin/env bash

### strings

## repeat a string
repeat_string() {

    local repeat="${1:-0}"
    local less="${2:-0}"
    local separator="${3:- }"

    for ((count = 0; count < repeat - less; count++)); do
        echo -n "${separator}"
    done
}

### arrays

## split a string into an array
array_string() {

    local IFS="${1}"
    read -r -a array <<<"${2}"
    echo "${array[@]}"

}

# execute a command on every array element
array_command() {

    local command="${1}"
    shift
    for array_element in "${@}"; do
        ${command} "${array_element}"
    done
}

# is the element contained in the array
array_in() {

    shopt -s extglob
    local element="${1}"
    shift
    local array=("${@}")
    [[ "$element" == @($(array_join '|' "${array[@]//|/\\|}")) ]]
}

# join array
array_join() {

    local IFS="${1}"
    shift
    echo "${*}"

}
