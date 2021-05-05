#!/usr/bin/env bash

# export all declared functions
export_declared_functions() {

    mapfile -t "__functions" <<<"$(get_declared_functions)"
    export -f "${__functions[@]}"

}

# executed before all commands
execute_after() {

    export TRAP_DEBUG_TIME_END="$(date +"%s.%N")"
    export PS1="$(get_shell_prompt_PS1)"
    #set_window_title "$(get_directory)■$(history -w /dev/stdout | tail -n 1)"
    unset TRAP_DEBUG_TIME_START
    unset TRAP_DEBUG_TIME_END

}

# executed before all commands
execute_before() {

    export TRAP_DEBUG_TIME_START="$(date +"%s.%N")"
    echo -e "$(get_shell_prompt_PS0)"

}

# xorg on login
start_xorg_server() {

    echo "Start xorg-server?"
    read -r answer
    [[ "$answer" != "n" && "$answer" != "N" ]] &&
        exec startx

}

# st in tabbed
stt() {

    #[[ -z $TABBED_XID ]] || export TABBED_XID=$(tabbed -d)
    #st -w "$TABBED_XID"
    tabbed -r 2 st -w ''

}

# send a notification
send_desktop_notification() {

    alert_message="${1:-" "}"
    alert_icon="${2:-"error"}"
    notify-send --urgency=low -i "${alert_icon}" "${alert_message}"

}

# source bashrc
sb() {

    source ~/.bashrc

}

# default compile command
mi() {

    make && sudo make install

}

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

# start vpn
yv() {

    echo '-hfo3-!W' | xclip -sel clip
    echo "token is in your clipboard"
    directory=~/Repositories/ya_vpn/
    config_file=~/Repositories/ya_vpn/openvpn.conf
    sudo openvpn --cd "${directory}" --config "${config_file}"

}

# default dmenu_path
dmenu_path_default() {

    cachedir="${XDG_CACHE_HOME:-"${HOME}/.cache"}"
    cache="${cachedir}/dmenu_run"

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

    # functtions will be shown first
    get_declared_functions
    #
    # other stuff is sorted by atime
    # by default, dmenu_path sorts executables alphabetically
    echo "${PATH}" | tr ':' '\n' | uniq | sed 's#$#/#' | # List directories in $PATH
        xargs ls -lu --time-style=+%s |                  # Add atime epoch
        awk '/^(-|l)/ { print $6, $7 }' |                # Only print timestamp and name
        sort -rn | cut -d' ' -f 2

}

# dmenu run
dmenu_run() {

    dmenu_path | dmenu "$@" | ${SHELL:-"/bin/sh"}

}

# history item
history_item() {

    history_item=$(
        history -w /dev/stdout | # shows history without numbers
            tac |                # reverses output, so recent entries are on top
            dmenu -l 10          # dmenu pipe
    )
    history -s "${history_item}"
    echo "${PS1@P}${history_item}"
    echo "${history_item}" | ${SHELL:-"/bin/sh"}

}

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

# source keymaps
source_keymaps() {

    userresources=~/.Xresources
    usermodmap=~/dot-files/configs/Xmodmap
    sysresources=/etc/X11/xinit/.Xresources
    sysmodmap=/etc/X11/xinit/.Xmodmap

    [[ -f "${sysresources}" ]] && xrdb -merge "${sysresources}"
    [[ -f "${sysmodmap}" ]] && xmodmap "${sysmodmap}"
    [[ -f "${userresources}" ]] && xrdb -merge "${userresources}"
    [[ -f "${usermodmap}" ]] && xmodmap "${usermodmap}"
    [[ -z "${1}" ]] || xmodmap "${1}"

}

# start xorg-server
sx() {

    startx

}

# vim
v() {

    vim "$@"

}

# unzip tar.gz and tar.xz
unzip_tr() {

    case "$(get_file_type "${1}")" in
    "xz")
        tar -xf "${1}"
        ;;

    *)
        tar -xvzf "${1}"
        ;;
    esac

}

# python aliases

# python
py() {

    python "$@"

}

# python virtual environment
pips() {

    export ENVIRONMENT="pipenv"
    pipenv shell
    unset ENVIRONMENT

}

# pip install
pipi() {

    pip install "$@"

}

# git aliases

# clone a repository
gc() {

    git clone "$@"

}

# default git push
gd() {

    message=${1:-"update"}
    day=${2:-"$(date +"%d")"}
    month=${3:-"$(date +"%m")"}
    year=${4:-"$(date +"%Y")"}
    date="${year}-${month}-${day} 00:00:00"

    export GIT_AUTHOR_DATE="${date}"
    export GIT_COMMITTER_DATE="${date}"
    git add .
    git commit -m "${message}"
    git push origin

}

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
            awk 'FNR == 3 {
                    print 100 - $15 "%";
                }'
    )
    traffic=$(
        sar -n DEV 1 1 |
            awk 'FNR == 6 {
                    printf("%.0fkB/s %.0fkB/s", $5, $6);
                }
            '
    )

    echo "[${memory}] [${cpu_temp} ${cpu_usage}] [${traffic}]"

}

# date
kde_date() {

    date +"[%A] [%B] [%Y-%m-%d] [%H:%M:%S:%3N]"

}

# code-oss
co() {

    source_keymaps
    workspace_file="${HOME}/dot-files/configs/vscode_workspace.code-workspace"
    code-oss --reuse-window --no-sandbox --unity-launch "${workspace_file}" "${1}"

}

# ls aliases

# default
l() {

    ls --color --human-readable "$@"

}

# hidden files
la() {

    l --all --size "$@"

}

# vertical
ll() {

    l -l --no-group "$@"

}

# cd
c() {

    directory="${1:-"${HOME}"}"
    cd "${directory}" || true
    l

}

# pacman aliases

# install a package
pm() {

    sudo pacman -S "$@"

}

# system update
pms() {

    pm -yu "$@"

}

# remove a package
pmr() {

    sudo pacman -R "$@"

}

# show files installed by a package
pmq() {

    sudo pacman -Ql "$@"

}

# logout aliases

# log out of the kde session
lo() {

    qdbus org.kde.ksmserver /KSMServer logout 0 3 3

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

# setup hard links
setup_hard_links() {

    cd ~/dot-files/ || exit
    #vscode_path=~/.config/Code/User/settings.json # path on windows
    vscode_path=~/.config/Code\ -\ OSS/User/settings.json
    firefox_path=~/.mozilla/firefox/zq1ebncv.default-release/chrome

    _ln() {
        rm "${2}" 2>/dev/null
        ln "${1}" "${2}"
    }
    _mkdir() {
        rm -r "${1}" 2>/dev/null
        mkdir "${1}"
    }
    _cp() { cp -r "${1}" "${2}" 2>/dev/null; }

    _ln "configs/vscode_settings.json" "${vscode_path}"
    _ln "scripts/bashrc.sh" ~/.bashrc
    _ln "scripts/xinitrc.sh" ~/.xinitrc
    _mkdir "${firefox_path}"
    _cp "firefox/img" "${firefox_path}"
    _ln "firefox/userChrome.css" "${firefox_path}/userChrome.css"
    _ln "firefox/userContent.css" "${firefox_path}/userContent.css"

}

# setup repositories
setup_repositories() {

    mkdir ~/Repositories
    cd ~/Repositories || exit
    repositories=(
        https://git.suckless.org/dmenu
        https://github.com/borinskikh/dot-files
        https://github.com/borinskikh/book-creator
        https://github.com/borinskikh/new-tab-bookmarks
        https://github.com/borinskikh/notes
    )

    for repository in "${repositories[@]}"; do
        git clone "${repository}"
    done

}

# getters and setters

# get list of functions
get_declared_functions() {

    declare -F | awk '{print $3}'

}

# return extension of the string provided
get_file_type() {

    echo "${1}" |
        awk -F'[.]' '{
            print $NF;
        }'

}

# get directory
get_directory() {

    pwd |
        awk -F'[/]' '{
            print $(NF-1) "/" $NF;
        }'
    # sed 's|/home/borinskikh/|~/|g'

}

# set window title
set_window_title() {

    echo -ne "\033]0;${1}\007"

}

# get current git branch
get_current_branch() {

    git branch --show-current 2>/dev/null

}

# get color code
get_color() {

    # text format, does not affect background
    #   0 - normal, 1 - bold,
    #   4 - underlined, 5 - blinking, 7 - reverse video
    # terminal color numbers
    #   foreground: 30 - 37
    #   background: 40 - 47

    echo "\[\e[${2:-"1"};${1:-"37"};${3:-"40"}m"

}
get_color-() { echo "\e[${2:-"1"};${1:-"37"};${3:-"40"}m"; }

# return end of color modification
get_color_end() {

    echo "\e[0m\]"

}
get_color_end-() { echo "\e[0m"; }

# get terminal colors
get_colors() {

    start=${1:-"0"}
    end=${2:-"7"}
    type_start=${3:-"-"} # print at the beginnning
    type_end=${4:-"-"}   # print at the end

    output() {
        number="${1:-"0"}"
        type="${2:-"0"}"
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

# generate the PS0 prompt
get_shell_prompt_PS0() {

    message="Start: $(date +"[%A] [%B] [%Y-%m-%d] [%H:%M:%S]")\n"
    separator_middle="$(get_color- 30)└$(get_shell_separator_line 2)┘$(get_color- 37)"
    set_window_title "$(get_directory)"

    echo "${separator_middle}"
    echo "${message}"

}

# generate the PS1 prompt
get_shell_prompt_PS1() {

    time_elapsed="$(bc <<<"${TRAP_DEBUG_TIME_END}-${TRAP_DEBUG_TIME_START}")"
    time_elapsed="$(printf "%.3f" "${time_elapsed}")"
    time_elapsed="$(get_color 32)Time elapsed: ${time_elapsed} seconds"
    time_end="End: $(date +"[%A] [%B] [%Y-%m-%d] [%H:%M:%S]")"
    time_end="$(get_color 37)${time_end}"
    separator_top="$(get_color 30)┌$(get_shell_separator_line 2)┐$(get_color 37)"
    separator="$(get_color 30)$(get_shell_separator_line)$(get_color 37)"
    [[ -z "$ENVIRONMENT" ]] || environment="$(get_color 31)[$ENVIRONMENT] "
    username="$(get_color 33)[\u] "
    hostname="$(get_color 37)[\H] "
    shell="$(get_color 36)[\s_\V] [\l:\j] "
    directory="$(get_color 34)[\w] "
    [[ -z "$(get_current_branch)" ]] || git_branch="$(get_color 35)[$(get_current_branch)] "
    #user_sign="$(get_color 37)\$ "
    colors_1="$(get_colors 0 2 1 -) "
    colors_2="$(get_colors 3 5 - 0) "
    colors_3="$(get_colors 5 7 1 -) "

    echo
    echo "${time_end}$(get_color_end)"
    echo "${separator}$(get_color_end)"
    echo "${colors_1}${username}${hostname}${shell}${environment}$(get_color_end)"
    echo "${colors_2}${directory}${git_branch}$(get_color_end)"
    echo "${colors_3}${time_elapsed}$(get_color_end)"
    echo "${separator_top}"
    echo "$(get_color 37) "
}

# shell command separator
get_shell_separator_line() {

    line_length=$(stty size | awk '{ print $2 }')
    line_length=$((${3:-"${line_length}"} - ${1:-"0"}))
    delimiter=${2:-"─"}
    eval printf -- "${delimiter}%.s" "{1..${line_length}}"
    # eval is needed since brace expansion precedes parameter expansion
    # double '-' since printf needs options
}

# get name of the process by PID
get_name_of_the_process() {

    ps -p "${1}" -o comm=

}

#########################
#########################

export_declared_functions

#########################
#########################
