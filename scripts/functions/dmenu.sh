#!/usr/bin/env bash

# dmenu

# default dmenu_path
dmenu_path_default() {

    local cachedir=${XDG_CACHE_HOME:-"${HOME}/.cache"}
    local cache="${cachedir}/dmenu_run"

    [ ! -e "${cachedir}" ] && mkdir -p "${cachedir}"

    IFS=:
    if stest -dqr -n "${cache}" "${PATH}"; then
        stest -flx "${PATH}" | sort -u | tee "${cache}"
    else
        cat "${cache}"
    fi

}

# output a list of commands for dmenu_run()
dmenu_path() {

    #. "${HOME}/.bashrc"
    local declared_functions path query
    
    ## other stuff is sorted by atime
    ## by default, dmenu_path sorts executables alphabetically
    # list directories in ${PATH}
    path="$(echo "${PATH}" | tr ':' '\n')"
    path="$(echo "${path}" | uniq | sed 's#$#/#')"
    # add the time epoch
    path="$(echo "${path}" | xargs ls -lu --time-style=+%s)"
    # only print the timestamp and the name
    path="$(echo "${path}" | awk '/^(-|l)/ { print $(6), $(7) }')"
    # sort by time and remove time
    path="$(echo "${path}" | sort -rn | cut -d' ' -f 2)"

    ## functions will be shown first
    # only those that do not start with "_"
    echo "$(get_declared_functions | awk '$(1) !~ /^_/ { print $(1) }')"
    # path
    echo "${path}"

}

# main dmenu function
dmenu_run() {

    #. "${HOME}/.bashrc"
    dmenu_path | dmenu "${@}" | ${SHELL:-"/bin/sh"} &

}
