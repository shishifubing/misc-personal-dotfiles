#!/usr/bin/env bash

# pacman aliases

# install a package
pm() {

    sudo pacman -S "${@}"

}

# system update
pms() {

    pm -yu "${@}"
    # use Firejail by default for all applications for which it has profiles
    # you need to run it only once but if you install something new
    # then you need to run it again
    echo
    echo "updating Firejail configuration"
    echo
    sudo firecfg

}

# remove a package
pmr() {

    sudo pacman -R "${@}"

}

# show files installed by a package
pmq() {

    sudo pacman -Ql "${@}"

}
