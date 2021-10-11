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

