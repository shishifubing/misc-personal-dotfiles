#!/usr/bin/env bash

# logout aliases

# log out of the kde session
lo() {

    qdbus org.kde.ksmserver /KSMServer logout 0 3 3

}

# suspend
losp() {

    sudo systemctl suspend

}

# lock session
lol() {

    loginctl lock-session 1

}

# reboot
lor() {

    reboot

}

# shutdown immediately
los() {

    shutdown now

}
