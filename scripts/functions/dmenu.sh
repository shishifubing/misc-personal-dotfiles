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

# dmenu_path, used by dmenu (dmenu_run)
dmenu_path() {

    # functions will be shown first
    # only those that do not start with "_"
    get_declared_functions | awk '$(1) !~ /^_/ { print $(1) }'
    # other stuff is sorted by atime
    # by default, dmenu_path sorts executables alphabetically
    echo "${PATH}" | tr ':' '\n' | uniq | sed 's#$#/#' | # list directories in $PATH
        xargs ls -lu --time-style=+%s |                  # add atime epoch
        awk '/^(-|l)/ { print $(6), $(7) }' |            # only print timestamp and name
        sort -rn | cut -d' ' -f 2                        # sort by time and remove it

}

# dmenu run
dmenu_run() {

    source_bashrc
    dmenu_path | dmenu "${@}" | ${SHELL:-"/bin/sh"}

}
