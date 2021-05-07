#!/usr/bin/env bash

# executed before all commands and before the prompt
# preexec.sh does the same but it is overkill

# {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

preexec() {

    export TRAP_DEBUG_TIME_START=$(date +"%s.%N")
    #set_window_title "$(get_directory)■$(history -w /dev/stdout 1)"
    echo -e "$(get_shell_prompt_PS0)"

}

precmd() {

    export TRAP_DEBUG_TIME_END=$(date +"%s.%N")
    export PS1=$(get_shell_prompt_PS1)
    unset TRAP_DEBUG_TIME_START TRAP_DEBUG_TIME_END

}

# }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

# random stuff
# {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

# convert time
convert_time() {

    local input="${1/.*/}"
    local fraction="${1/*./}"
    local seconds=0
    local minutes=0
    local hours=0
    local days=0

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

    [[ "${days}" != "0" ]] && local days_output="${days} days "
    [[ "${hours}" != "0" ]] && local hours_output="${hours} hours "
    [[ "${minutes}" != "0" ]] && local minutes_output="${minutes} minutes "
    local seconds_output="${seconds}.${fraction} seconds"

    echo "${days_output}${hours_output}${minutes_output}${seconds_output}"

}

# st in tabbed
stt() {

    #[[ -z $TABBED_XID ]] || export TABBED_XID=$(tabbed -d)
    #st -w "$TABBED_XID"
    tabbed -r 2 st -w ''

}

# send a notification
send_desktop_notification() {

    local alert_message=${1:-" "}
    local alert_icon=${2:-"error"}
    notify-send --urgency=low -i "${alert_icon}" "${alert_message}"

}

# default compile command
mi() {

    make && sudo make install

}

# password manager script
passmenu() {

    shopt -s nullglob globstar
    local typeit=0
    if [[ "${1}" == "--type" ]]; then
        typeit=1
        shift
    fi
    local prefix="${PASSWORD_STORE_DIR-~/.password-store}"
    local password_files=("${prefix}"/**/*.gpg)
    password_files=("${password_files[@]#"${prefix}"/}")
    password_files=("${password_files[@]%.gpg}")
    local password=$(printf '%s\n' "${password_files[@]}" | dmenu "$@")
    [[ -n "${password}" ]] || exit
    if [[ "${typeit}" -eq 0 ]]; then
        pass show -c "${password}" 2>/dev/null
    else
        pass show "${password}" | {
            IFS= read -r pass
            printf %s "${pass}"
        } |
            xdotool type --clearmodifiers --file -
    fi

}

# start vpn
yv() {

    echo '-hfo3-!W' | xclip -sel clip
    echo "token is in your clipboard"
    local directory="${HOME}/Repositories/ya_vpn/"
    local config_file="${HOME}/Repositories/ya_vpn/openvpn.conf"
    sudo openvpn --cd "${directory}" --config "${config_file}"

}
# code-oss
co() {

    source_keymaps
    local workspace_file="${HOME}/dot-files/configs/vscode_workspace.code-workspace"
    code-oss --reuse-window --no-sandbox --unity-launch "${workspace_file}" "${1}"

}

# history item
history_item() {

    # show history without numbers and reverse output
    local history_item=$(history -w /dev/stdout | tac | dmenu -l 10)
    history -s "${history_item}"
    echo "${PS1@P}${history_item}"
    echo "${history_item}" | ${SHELL:-"/bin/sh"}

}

db() {

    if [[ -n "${DATABASE_KEY}" ]]; then
        local choice=$(
            echo "
                PRAGMA key = '${DATABASE_KEY}';
                SELECT location, login FROM passwords;
            " |
                sqlcipher ~/Repositories/dot-files/db.db |
                awk 'NR > 3' | dmenu -l 5
        )
        echo "
            PRAGMA key = '${DATABASE_KEY}';
            SELECT password FROM passwords WHERE login==\"${choice}\"
        " |
            sqlcipher "${HOME}/Repositories/dot-files/db.db" |
            xclip -sel clip
    fi

}

# vim
v() {

    vim "${@}"

}

# unzip tar.gz and tar.xz
unzip_tr() {

    case "$(get_file_type "${1}")" in
    "xz") tar -xf "${1}" ;;
    *) tar -xvzf "${1}" ;;
    esac

}

# }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

# xorg
# {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

# start xorg-server
sx() {

    startx

}

# xorg on login
start_xorg_server() {

    # use Firejail by default for all applications for which it has profiles
    # you need to run it only once but if you install something new
    # then you need to run it again
    sudo firecfg | /dev/null
    # xorg
    echo -e "$(get_shell_separator_line)"
    echo "Start xorg-server?"
    echo -e "$(get_shell_separator_line)"
    read -r answer
    [[ "${answer}" != "n" && "${answer}" != "N" ]] && exec startx

}

# }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

# dmenu
# {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

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

    # functtions will be shown first
    get_declared_functions
    #
    # other stuff is sorted by atime
    # by default, dmenu_path sorts executables alphabetically
    echo "${PATH}" | tr ':' '\n' | uniq | sed 's#$#/#' | # list directories in $PATH
        xargs ls -lu --time-style=+%s |                  # add atime epoch
        awk '/^(-|l)/ { print $(6), $(7) }' |            # only print timestamp and name
        sort -rn | cut -d' ' -f 2                        # sort by time and remove it

}

# dmenu run
dmenu_run() {

    dmenu_path | dmenu "${@}" | ${SHELL:-"/bin/sh"}

}

# }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

# python aliases
# {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

# python
py() {

    python "${@}"

}

# python virtual environment
pips() {

    export ENVIRONMENT="pipenv"
    pipenv shell
    unset ENVIRONMENT

}

# pip install
pipi() {

    pip install "${@}"

}

# }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

# git
# {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

# clone a repository
gc() {

    git clone "${@}"

}

# default git push
gd() {

    local message=${1:-"update"}
    local day=${2:-"$(date +"%d")"}
    local month=${3:-"$(date +"%m")"}
    local year=${4:-"$(date +"%Y")"}
    local date="${year}-${month}-${day} 00:00:00"

    export GIT_AUTHOR_DATE="${date}"
    export GIT_COMMITTER_DATE="${date}"
    git add .
    git commit -m "${message}"
    git push origin

}

# }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

# kde aliases
# {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

# resources
kde_resources() {

    local memory=$(
        free -h | # show memory in human readable form
            awk '
                FNR == 2 {
                    ram_usage=$(3); total_memory=$(2);
                };
                FNR == 3 {
                    swap_usage=$(3);
                    print ram_usage "+" swap_usage "/" total_memory;
                };
            '
    )
    # outputs only the first two symbols of the file
    local cpu_temp="$(cut -c1-2 /sys/class/thermal/thermal_zone0/temp)°C"
    local cpu_usage=$(vmstat | awk 'FNR == 3 { print 100 - $(15) "%" }')
    local traffic=$(
        sar -n DEV 1 1 |
            awk 'FNR == 6 { printf("%.0fkB/s %.0fkB/s", $(5), $(6)) }'
    )

    echo "[${memory}] [${cpu_temp} ${cpu_usage}] [${traffic}]"

}

# date
kde_date() {

    date +"[%A] [%B] [%Y-%m-%d] [%H:%M:%S:%3N]"

}

# }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

# ls aliases
# {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

# default
l() {

    ls --color --human-readable "${@}"

}

# hidden files
la() {

    l --all --size "${@}"

}

# vertical
ll() {

    l -l --no-group "${@}"

}

# cd
c() {

    cd "${1:-${HOME}}" || true
    l

}

# }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

# pacman aliases
# {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

# install a package
pm() {

    sudo pacman -S "${@}"

}

# system update
pms() {

    pm -yu "${@}"

}

# remove a package
pmr() {

    sudo pacman -R "${@}"

}

# show files installed by a package
pmq() {

    sudo pacman -Ql "${@}"

}

# }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

# logout aliases
# {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

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

# }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

# setup
# {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

# source keymaps
source_keymaps() {

    local userresources="${HOME}/.Xresources"
    local usermodmap="${HOME}/dot-files/configs/Xmodmap"
    local sysresources="/etc/X11/xinit/.Xresources"
    local sysmodmap="/etc/X11/xinit/.Xmodmap"

    [[ -f "${sysresources}" ]] && xrdb -merge "${sysresources}"
    [[ -f "${sysmodmap}" ]] && xmodmap "${sysmodmap}"
    [[ -f "${userresources}" ]] && xrdb -merge "${userresources}"
    [[ -f "${usermodmap}" ]] && xmodmap "${usermodmap}"
    [[ -z "${1}" ]] || xmodmap "${1}"

}

# source file
source_files_if_exist() {

    for file in "${@}"; do
        [[ -f "${file}" ]] && . "${file}"
    done

}

# source bashrc
sb() {

    source "${HOME}/.bashrc"

}

# setup hard links
setup_hard_links() {

    local path="${1:-${HOME}}/dot-files"
    local scripts="${path}/scripts"
    local configs="${path}/configs"
    local firefox="${path}/firefox"
    local vscode_path="${HOME}/.config/Code - OSS/User/settings.json"
    local vscode_config="${configs}/vscode_settings.json"
    local bashrc="${scripts}/bashrc.sh"
    local xinitrc="${scripts}/xinitrc.sh"
    local firefox_path="${HOME}/.mozilla/firefox/${2:-zq1ebncv.default-release}/chrome"
    local firefox_userChrome="${firefox}/userChrome.css"
    local firefox_userContent="${firefox}/userContent.css"
    local firefox_img="${firefox}/img"

    _ln() {
        rm "${2}" 2>/dev/null
        ln "${1}" "${2}"
    }
    _mkdir() {
        rm -r "${1}" 2>/dev/null
        mkdir "${1}"
    }
    _cp() { cp -r "${1}" "${2}" 2>/dev/null; }

    _ln "${vscode_config}" "${vscode_path}"
    _ln "${bashrc}" "${HOME}/.bashrc"
    _ln "${xinitrc}" "${HOME}/.xinitrc"
    _mkdir "${firefox_path}"
    _cp "${firefox_img}" "${firefox_path}"
    _ln "${firefox_userChrome}" "${firefox_path}/userChrome.css"
    _ln "${firefox_userContent}" "${firefox_path}/userContent.css"

}

# setup repositories
setup_repositories() {

    mkdir "${HOME}/${1:-Repositories}" 2>/dev/null
    cd "${HOME}/${1-Repositories}" || exit
    local repositories=(
        "https://git.suckless.org/dmenu"
        "https://github.com/borinskikh/dot-files"
        "https://github.com/borinskikh/book-creator"
        "https://github.com/borinskikh/notes"
    )

    for repository in "${repositories[@]}"; do
        git clone "${repository}"
    done

}

# }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

# getters and setters
# {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

# get list of functions
get_declared_functions() {

    declare -F | awk '{ print $(3) }'

}

# return extension of the string provided
get_file_type() {

    echo "${1}" | awk -F'[.]' '{ print $(NF) }'

}

# get directory
get_directory() {

    pwd | awk -F'[/]' '{ print $(NF-1) "/" $(NF) }'

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
    #   0 - normal, 1 - bold, 4 - underlined,
    #   5 - blinking, 7 - reverse video
    # terminal color numbers
    #   foreground: 30 - 37; background: 40 - 47
    [[ "${1}" == "-" ]] && local bracket="\e" && shift
    echo "${bracket:-\[\e}[${2:-1};${1:-37};${3:-40}m"

}

# return end of color modification
get_color_end() {

    [[ "${1}" == "-" ]] && local bracket="m"
    echo "\e[0${bracket:-\]m}"

}

# get terminal colors
get_colors() {

    local start=${1:-"0"}
    local end=${2:-"7"}
    local type_start=${3:-"-"} # print at the beginnning
    local type_end=${4:-"-"}   # print at the end

    output() {
        local number=${1:-"0"}
        local type=${2:-"0"}
        local color=$(get_color "$((number + 30))" "${type}" "$((number + 40))")
        echo "${color}██$(get_color_end)"
    }
    for ((color = start; color <= end; color++)); do
        if [[ "${color}" == "${start}" && "${type_start}" != "-" ]]; then
            echo -n "$(output "${color}" "${type_start}")"
        elif [[ "${color}" == "${end}" && "${type_end}" != "-" ]]; then
            echo -n "$(output "${color}" "${type_end}")"
        else
            echo -n "$(output "${color}" "0")$(output "${color}" "1")"
        fi
    done

}

# generate the PS0 prompt
get_shell_prompt_PS0() {

    local message="Start: $(date +"[%A] [%B] [%Y-%m-%d] [%H:%M:%S]")\n"
    local separator_middle="$(get_color - 30)$(get_shell_separator_line 0 ▲)$(get_color - 37)"
    set_window_title "$(get_directory)"

    echo "${separator_middle}"
    echo "${message}"

}

# generate the PS1 prompt
get_shell_prompt_PS1() {

    local gc_30=$(get_color 30)
    local gc_31=$(get_color 31)
    local gc_32=$(get_color 32)
    local gc_33=$(get_color 33)
    local gc_34=$(get_color 34)
    local gc_35=$(get_color 35)
    local gc_36=$(get_color 36)
    local gc_37=$(get_color 37)
    local gc_end=$(get_color_end)
    local date=$(date +"[%A] [%B] [%Y-%m-%d] [%H:%M:%S]")
    local separ_line_top=$(get_shell_separator_line 0 ▲)
    local separ_line_bot=$(get_shell_separator_line 0 ▼)
    local branch=$(get_current_branch)
    local time_elapsed=$(bc <<<"${TRAP_DEBUG_TIME_END}-${TRAP_DEBUG_TIME_START}")
    local time_elapsed=$(convert_time "$(printf "%.6f" "${time_elapsed}")")

    local time_elapsed="${gc_32}[${time_elapsed}]"
    local time_end="${gc_37}End: ${date}"
    local separator_top="${gc_30}${separ_line_top}${gc_37}"
    local separator_bot="${gc_30}${separ_line_bot}${gc_37}"
    [[ -z "$ENVIRONMENT" ]] || local environment="${gc_31}[$ENVIRONMENT] "
    local username="${gc_33}[\u] "
    local hostname="${gc_37}[\H] "
    local shell="${gc_36}[\s_\V] [\l:\j] "
    local directory="${gc_34}[\w] "
    [[ -z "${branch}" ]] || local git_branch="${gc_35}[${branch}] "
    #local user_sign="${gc_37}\$ "
    local colors_1="$(get_colors 0 2 1 -) "
    local colors_2="$(get_colors 3 5 - 0) "
    local colors_3="$(get_colors 5 7 1 -) "

    echo
    echo "${time_end}${gc_end}"
    echo "${separator_bot}${gc_end}"
    echo "${colors_1}${username}${hostname}${shell}${environment}${gc_end}"
    echo "${colors_2}${directory}${git_branch}${gc_end}"
    echo "${colors_3}${time_elapsed}${gc_end}"
    echo #"${separator_top}${gc_end}"
    echo "${gc_37}"
}

# shell command separator
get_shell_separator_line() {

    local line_length=$(stty size | awk '{ print $(2) }')
    local line_length=$((${3:-${line_length}} - ${1:-"0"}))
    local separator=${2:-"─"}
    eval printf -- "${separator}%.s" "{1..${line_length}}"
    # eval is needed since brace expansion precedes parameter expansion
    # double '-' since printf needs options
}

# get name of the process by PID
get_name_of_the_process() {

    ps -p "${1}" -o comm=

}

# }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

# export all declared functions
# {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

export_declared_functions() {

    mapfile -t "functions" <<<"$(get_declared_functions)"
    export -f "${functions[@]}"

}

#export_declared_functions

# }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
