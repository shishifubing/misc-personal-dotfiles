#!/usr/bin/env bash

# pacman aliases

# install a package
pm() {

    sudo pacman -S "${@}"

}

# system update
pms() {

    pm -yu "${@}" || return 1
    # use Firejail by default for all applications for which it has profiles
    # you need to run it only once but if you install something new
    # then you need to run it again
    get_shell_separator_line
    echo "running firejail..."
    sudo firecfg > /dev/null

}

# remove a package
pmr() {

    sudo pacman -R "${@}"

}

# show files installed by a package
pmq() {

    sudo pacman -Ql "${@}"

}
