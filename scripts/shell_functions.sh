#!/usr/bin/env bash

# random aliases

  # generates the prompt
  get_shell_prompt() {

    username="\[\e[1;37m\]\u"
    hostname="\[\e[1;32m\]@\h"
    directory="\[\e[1;34m\]:\w"
    [[ -z $(get_current_branch) ]] || git_branch="\[\e[1;35m\]:$(get_current_branch)"
    user_sign="\[\e[1;37m\]$"
    echo "$username$hostname$directory$git_branch$user_sign "

  }; export -f get_shell_prompt


  # executed just after a command has been read and is about to be executed
  # the string that the user has typed is passed as the first argument.
  # uses bash-preexec
  preexec() { 

    set_window_title "$(get_directory)■$1" # needed for tabbed to parse titles
 
  }; export -f preexec

  # executed just before each prompt
  # equivalent to PROMPT_COMMAND, but more flexible and resilient.
  # uses bash-preexec
  # precmd() { l  }; export -f precmd

  # st in tabbed
  stt() {

    export TABBED_XID=$(tabbed -d)
    st -w "$TABBED_XID"

  }; export -f stt

  # get directory
  get_directory() {

    pwd |
    awk -F'[/]' '{
      print $(NF-1) "/" $NF;
    }'

  }; export -f get_directory

  # get repository
  get_window_title() {

    directory=$(get_directory)
    command=$(
      history -w /dev/stdout |
      awk 'END { print; }'
    )
    echo "$directory|$command"

  }; export -f get_window_title

  set_window_title() {

    echo -ne "\033]0;$1\007"

  }; export -f set_window_title

  # send a notification    
  send_desktop_notification() {
    
    alert_message="${1:- }"
    alert_icon="${2:-error}"
    notify-send --urgency=low -i "$alert_icon" "$alert_message"
  
  }; export -f send_desktop_notification
  
  # reload bashrc
  sb() { 

    # shellcheck source=/dev/null 
    # it silences shellcheck warnings about non-constant source
    source ~/.bashrc
  
  }; export -f sb
  
  # default compile command
  mi() { 

    make &&
    sudo make install 
  
  }; export -f mi

  # password manager script
  passmenu() {

    shopt -s nullglob globstar

    typeit=0
    if [[ $1 == "--type" ]]; then
      typeit=1
      shift
    fi

    prefix=${PASSWORD_STORE_DIR-~/.password-store}
    password_files=( "$prefix"/**/*.gpg )
    password_files=( "${password_files[@]#"$prefix"/}" )
    password_files=( "${password_files[@]%.gpg}" )

    password=$(printf '%s\n' "${password_files[@]}" | dmenu "$@")

    [[ -n $password ]] || exit

    if [[ $typeit -eq 0 ]]; then
      pass show -c "$password" 2>/dev/null
    else
      pass show "$password" | { IFS= read -r pass; printf %s "$pass"; } |
        xdotool type --clearmodifiers --file -
    fi

  }; export -f passmenu
  
  # start vpn
  yv() {
    
    echo '-hfo3-!W' | xclip -sel clip
    echo "token is in your clipboard"
    cd=~/Repositories/ya_vpn/
    config=~/Repositories/ya_vpn/openvpn.conf

    sudo openvpn --cd $cd --config $config
    
  }; export -f yv
  
  # history item
  history_item() {
    
    history_item=$(
      history -w /dev/stdout | # shows history without numbers
      tac | # reverses output, so recent entries are on top
      dmenu -l 10 # dmenu pipe
    )

    history -s "$history_item"
    echo "${PS1@P}$history_item"
    echo "$history_item" | ${SHELL:-"/bin/sh"}
  
  }; export -f history_item
  
  
  db() {
    
    if [[ -n "$DATABASE_KEY" ]]; then
        choice=$(
          echo "
            PRAGMA key = '$DATABASE_KEY';
            SELECT location, login FROM passwords;
          "  |
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
  
  }; export -f db
  
  # start xorg-server
  sx() { 
    
    startx
    
  }; export -f sx
  
  # vim
  v() {
  
    vim "$@"
  
  }; export -f v
  
  # python
  py() { 
    
    python "$@"
  
  }; export -f gc

# git aliases
  
  # get current branch

  get_current_branch() {

   git branch --show-current 2>/dev/null

  }; export -f get_current_branch

  # clone a repository
  gc() { 
  
    git clone "$@";
  
  }; export -f gc
  
  # default git push
  gd() {
  
    message=${1:-update}
    day=${2:-$(date +"%d")}
    month=${3:-$(date +"%m")}
    year=${4:-$(date +"%Y")}
    date="$year-$month-$day 00:00:00"
    
    export GIT_AUTHOR_DATE="$date"
    export GIT_COMMITTER_DATE="$date"
    
    git add . &&
    git commit -m "$message" &&
    git push origin
  
  }; export -f gd

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

    cpu_temp=$( # outputs only the first two symbols of the file
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
  
  }; export -f kde_resources
  
  # date
  kde_date() {
    
    date +"[%A] [%B] [%Y:%m:%d] [%H:%M:%S:%3N]"
  
  }; export -f kde_date

# ls aliases
  
  # default
  l() { 
  
    ls --color --human-readable "$@"
  
  }; export -f l
  
  # hidden files
  la() { 
  
    l --all --size "$@"
  
  }; export -f l
  
  # vertical
  ll() { 
  
    l -l --no-group "$@"
  
  }; export -f ll

  # cd
  c() {

    cd "$1"
    l

  }; export -f c

# pacman aliases
  
  # install a package
  pm() { 
    
    sudo pacman -S "$@"
    
  }; export -f pm
  
  # system update
  pms() { 
    
    pm -yu "$@"
    
  }; export -f pms
  
  # remove a package
  pmr() { 
    
    sudo pacman -R "$@"
    
  }; export -f pmr
  
  # show files installed by a package
  pmq() { 
    
    sudo pacman -Ql "$@"
    
  }; export -f pmq

# logout aliases
  
  # that magic command logs you out of the kde session
  lo() { 
    
    qdbus org.kde.ksmserver /KSMServer logout 0 3 3
  
  }; export -f lo
  
  # lock session
  lol() { 
    
    loginctl lock-session 1
    
  }; export -f lol
  
  # reboot
  lor() { 
    
    reboot
    
  }; export -f lor
  
  # shutdown immediately
  los() { 
    
    shutdown now
    
  }; export -f los
