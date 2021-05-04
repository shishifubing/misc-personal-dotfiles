#!/usr/bin/env bash

# executed before all commands
execute_after() {

    set_window_title "$(get_directory)■$(history -w /dev/stdout | tail -n 1)"
    PS1="$(get_shell_prompt_PS1)" && export PS1
    unset TRAP_DEBUG_START_TIME

}
export -f execute_after

# executed before all commands
execute_before() {

    echo -e "$(get_shell_prompt_PS0)"
    TRAP_DEBUG_START_TIME="$(date +"%s.%N")" && export TRAP_DEBUG_START_TIME

}
export -f execute_before

# xorg on login
start_xorg_server() {

    echo "Start xorg-server?"
    read -r answer
    [[ "$answer" != "n" && "$answer" != "N" ]] &&
        exec startx

}
export -f start_xorg_server

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
enable_programmable_completion_features() {

    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi

}
export -f enable_programmable_completion_features

# st in tabbed
stt() {

    #[[ -z $TABBED_XID ]] || export TABBED_XID=$(tabbed -d)
    #st -w "$TABBED_XID"
    tabbed -r 2 st -w ''

}
export -f stt

# merge in defaults and keymaps
source_keymaps() {

    userresources=~/.Xresources
    usermodmap=~/dot-files/configs/Xmodmap
    sysresources=/etc/X11/xinit/.Xresources
    sysmodmap=/etc/X11/xinit/.Xmodmap

    [[ -f "$sysresources" ]] && xrdb -merge "$sysresources"
    [[ -f "$sysmodmap" ]] && xmodmap "$sysmodmap"
    [[ -f "$userresources" ]] && xrdb -merge "$userresources"
    [[ -f "$usermodmap" ]] && xmodmap "$usermodmap"
    [[ -z "$1" ]] || xmodmap "$1"

}
export -f source_keymaps

# send a notification
send_desktop_notification() {

    alert_message="${1:- }"
    alert_icon="${2:-error}"
    notify-send --urgency=low -i "$alert_icon" "$alert_message"

}
export -f send_desktop_notification

# source bashrc
sb() {

    source ~/.bashrc

}
export -f sb

# default compile command
mi() {

    make && sudo make install

}
export -f mi

# password manager script
passmenu() {

    shopt -s nullglob globstar
    typeit=0
    if [[ $1 == "--type" ]]; then
        typeit=1
        shift
    fi
    prefix=${PASSWORD_STORE_DIR-~/.password-store}
    password_files=("$prefix"/**/*.gpg)
    password_files=("${password_files[@]#"$prefix"/}")
    password_files=("${password_files[@]%.gpg}")
    password=$(printf '%s\n' "${password_files[@]}" | dmenu "$@")
    [[ -n $password ]] || exit
    if [[ $typeit -eq 0 ]]; then
        pass show -c "$password" 2>/dev/null
    else
        pass show "$password" | {
            IFS= read -r pass
            printf %s "$pass"
        } |
            xdotool type --clearmodifiers --file -
    fi

}
export -f passmenu

# start vpn
yv() {

    echo '-hfo3-!W' | xclip -sel clip
    echo "token is in your clipboard"
    directory=~/Repositories/ya_vpn/
    config_file=~/Repositories/ya_vpn/openvpn.conf
    sudo openvpn --cd $directory --config $config_file

}
export -f yv

# history item
history_item() {

    history_item=$(
        history -w /dev/stdout | # shows history without numbers
            tac |                # reverses output, so recent entries are on top
            dmenu -l 10          # dmenu pipe
    )
    history -s "$history_item"
    echo "${PS1@P}$history_item"
    echo "$history_item" | ${SHELL:-"/bin/sh"}

}
export -f history_item

db() {

    if [[ -n "$DATABASE_KEY" ]]; then
        choice=$(
            echo "
                PRAGMA key = '$DATABASE_KEY';
                SELECT location, login FROM passwords;
            " |
                sqlcipher ~/Repositories/dot-files/db.db |
                awk 'NR > 3' |
                dmenu -l 5
        )
        echo "
            PRAGMA key = '$DATABASE_KEY';
            SELECT password FROM passwords WHERE login==\"$choice\"
        " |
            sqlcipher ~/Repositories/dot-files/db.db |
            xclip -sel clip
    fi

}
export -f db

# start xorg-server
sx() {

    startx

}
export -f sx

# vim
v() {

    vim "$@"

}
export -f v

# unzip tar.gz and tar.xz
tr() {

    case "$(get_file_type "${1}")" in
    "xz")
        tar -xf "$1"
        ;;

    *)
        tar -xvzf "$1"
        ;;
    esac

}

export -f tr

# python aliases

# python
py() {

    python "$@"

}
export -f py

# python virtual environment
pips() {

    export ENVIRONMENT="pipenv"
    pipenv shell
    unset ENVIRONMENT

}
export -f pips

# pip install
pipi() {

    pip install "$@"

}
export -f pipi

# git aliases

# clone a repository
gc() {

    git clone "$@"

}
export -f gc

# default git push
gd() {

    message=${1:-update}
    day=${2:-$(date +"%d")}
    month=${3:-$(date +"%m")}
    year=${4:-$(date +"%Y")}
    date="$year-$month-$day 00:00:00"

    export GIT_AUTHOR_DATE="$date"
    export GIT_COMMITTER_DATE="$date"
    git add .
    git commit -m "$message"
    git push origin

}
export -f gd

# kde aliases

# resources
kde_resources() {

    memory=$(
        free -h | # show memory in human readable form
            awk '
        FNR == 2 {
          ram_usage=$3; total_memory=$2;
        };
        FNR == 3 {
          swap_usage=$3;
          print ram_usage "+" swap_usage "/" total_memory;
        };
      '
    )
    cpu_temp=$(# outputs only the first two symbols of the file
        cut -c1-2 /sys/class/thermal/thermal_zone0/temp
    )°C
    cpu_usage=$(
        vmstat |
            awk '
        FNR == 3 {
          print 100 - $15 "%";
        }
      '
    )
    traffic=$(
        sar -n DEV 1 1 |
            awk '
        FNR == 6 {
          printf("%.0fkB/s %.0fkB/s", $5, $6);
        }
      '
    )

    echo "[$memory] [$cpu_temp $cpu_usage] [$traffic]"

}
export -f kde_resources

# date
kde_date() {

    date +"[%A] [%B] [%Y-%m-%d] [%H:%M:%S:%3N]"

}
export -f kde_date

# code-oss
co() {

    workspace_file=~/dot-files/configs/vscode_workspace.code-workspace
    code-oss --reuse-window --no-sandbox --unity-launch "$workspace_file" "$1"

}
export -f co

# ls aliases

# default
l() {

    ls --color --human-readable "$@"

}
export -f l

# hidden files
la() {

    l --all --size "$@"

}
export -f l

# vertical
ll() {

    l -l --no-group "$@"

}
export -f ll

# cd
c() {
    directory="${1:-/home/borinskikh}"
    cd "$directory" || true
    l

}
export -f c

# pacman aliases

# install a package
pm() {

    sudo pacman -S "$@"

}
export -f pm

# system update
pms() {

    pm -yu "$@"

}
export -f pms

# remove a package
pmr() {

    sudo pacman -R "$@"

}
export -f pmr

# show files installed by a package
pmq() {

    sudo pacman -Ql "$@"

}
export -f pmq

# logout aliases

# log out of the kde session
lo() {

    qdbus org.kde.ksmserver /KSMServer logout 0 3 3

}
export -f lo

# lock session
lol() {

    loginctl lock-session 1

}
export -f lol

# reboot
lor() {

    reboot

}
export -f lor

# shutdown immediately
los() {

    shutdown now

}
export -f los

# getters and setters

# return extension of the string provided
get_file_type() {

    echo "$1" |
        awk -F'[.]' '{
            print $NF;
        }'

}
export -f get_file_type

# get directory
get_directory() {

    pwd |
        awk -F'[/]' '{
            print $(NF-1) "/" $NF;
        }'
    # sed 's|/home/borinskikh/|~/|g'

}
export -f get_directory

# set window title
set_window_title() {

    echo -ne "\033]0;${1}\007"

}
export -f set_window_title

# get current git branch
get_current_branch() {

    git branch --show-current 2>/dev/null

}
export -f get_current_branch

# get color code
get_color() {

    # text format, does not affect background
    #   0 - normal, 1 - bold,
    #   4 - underlined, 5 - blinking, 7 - reverse video
    # terminal color numbers
    #   foreground: 30 - 37
    #   background: 40 - 47

    echo "\[\e[${2:-1};${1:-37};${3:-40}m"

}
export -f get_color

# get terminal colors
get_colors() {

    start=${1:-"0"}
    end=${2:-"7"}
    type_start=${3:-"-"} # print at the beginnning
    type_end=${4:-"-"}   # print at the end

    output() {
        number="${1:-0}"
        type="${2:-0}"
        color=$(get_color "$((number + 30))" "${type}" "$((number + 40))")
        echo "${color}██$(get_color_end)"
    }
    for ((color = start; color <= end; color++)); do
        if [[ "${color}" == "${start}" && ${type_start} != "-" ]]; then
            echo -n "$(output "${color}" "${type_start}")"
        elif [[ "${color}" == "${end}" && ${type_end} != "-" ]]; then
            echo -n "$(output "${color}" "${type_end}")"
        else
            echo -n "$(output "${color}" "0")$(output "${color}" "1")"
        fi
    done

}

export -f get_colors

# return end of color modification
get_color_end() {

    echo "\e[0m\]"

}

export -f get_color_end

# generate the PS0 prompt
get_shell_prompt_PS0() {

    message="Start: $(date +"[%A] [%B] [%Y-%m-%d] [%H:%M:%S]")\n"
    separator="\e[1;30m$(get_shell_separator_line ─)\e[1;37m"
    set_window_title "$(get_directory)"

    echo "${separator}"
    echo "${message}"

}
export -f get_shell_prompt_PS0

# generate the PS1 prompt
get_shell_prompt_PS1() {

    time_elapsed="$(bc <<<"$(date +"%s.%N") - ${TRAP_DEBUG_START_TIME}")"
    time_elapsed="$(get_color 37)Time elapsed: $(printf "%.3f" "${time_elapsed}") seconds"
    time_end="End: $(date +"[%A] [%B] [%Y-%m-%d] [%H:%M:%S]")"
    time_end="$(get_color 37)${time_end}"
    separator="$(get_color 30)$(get_shell_separator_line ─)$(get_color 37)"
    [[ -z "$ENVIRONMENT" ]] || environment="$(get_color 31)[$ENVIRONMENT] "
    username="$(get_color 33)[\u] "
    hostname="$(get_color 37)[\H] "
    shell="$(get_color 36)[\s_\V] [\l:\j] "
    directory="$(get_color 34)[\w] "
    [[ -z "$(get_current_branch)" ]] || git_branch="$(get_color 35)[$(get_current_branch)] "
    user_sign="$(get_color 37)$ "
    colors_1="$(get_colors 0 2 1 -) "
    colors_2="$(get_colors 3 5 - 0) "
    colors_3="$(get_colors 5 7 1 -) "

    echo
    echo "${time_end}$(get_color_end)"
    echo "${separator}$(get_color_end)"
    echo "${colors_1}${username}${hostname}${shell}${environment}$(get_color_end)"
    echo "${colors_2}${directory}${git_branch}$(get_color_end)"
    echo "${colors_3}${time_elapsed}$(get_color_end)"
    echo "${user_sign}$(get_color_end)$(get_color 37)"
}
export -f get_shell_prompt_PS1

# shell command separator
get_shell_separator_line() {

    line_length=${2:-"$(stty size | awk '{ print $2 }')"}
    delimiter=${1:-"─"}
    eval printf -- "${delimiter}%.s" "{1..${line_length}}"
    # eval is needed since brace expansion precedes parameter expansion
    # double '-' since printf needs options
}
export -f get_shell_separator_line

# get name of the process by PID
get_name_of_the_process() {

    ps -p "$1" -o comm=

}
export -f get_name_of_the_process
