#!/bin/bash

# If not running interactively, don't do anything
  case $- in
      *i*) ;;
        *) return;;
  esac

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
  shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
  #shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1) 

  [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
  
# set variable identifying the chroot you work in (used in the prompt below)

  if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
      debian_chroot=$(cat /etc/debian_chroot)
  fi

# set a fancy prompt (non-color, unless we know we "want" color)

  case "$TERM" in
      xterm-color|*-256color) color_prompt=yes;;
  esac
  
# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
  
  force_color_prompt=yes
  if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
      # We have color support; assume it's compliant with Ecma-48
      # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
      # a case would tend to support setf rather than setaf.)
      color_prompt=yes
    else
      color_prompt=
    fi
  fi
  if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
  else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
  fi
  unset color_prompt force_color_prompt
  
#If this is an xterm set the title to user@host:dir
  
  case "$TERM" in
    xterm*|rxvt*)
      PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
      ;;
    *)
      ;;
  esac
  
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc). 
  
  if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
  fi

# random variables

  export LC_ALL="en_US.UTF-8" # all locales are overwritten
  export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01' # colored GCC warnings and errors

# bash history

  export HISTFILE=~/.bash_history # bash history
  export HISTCONTROL="ignoreboth:erasedups" # don't put duplicate lines or lines starting with space in the bash history.
  export HISTFILESIZE= # unlimited bash history (file size)
  export HISTSIZE= # unlimited bash history (lines) 
  shopt -s histappend # append to the history file, don't overwrite it
  # flushes the command to the history file immediately (otherwise, this would happen only when the shell exits
  export PROMPT_COMMAND='
    history -a;
    printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"
  '

# bindings

  #bind -x '"\e[A": history_item' # up arrow
  #bind -x '"\e[B": history_item' # down arrow

# random aliases

  # send a notification    
  send_desktop_notification() {

    alert_message="${1:- }"
    alert_icon="${2:-error}"
    notify-send --urgency=low -i "$alert_icon" "$alert_message"

  }; export -f send_desktop_notification

  # show a vertical list of files with some info
  l() { 

    ls --color=auto -ahcFg "$@"
  
  }; export -f l

  # kde status
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
    echo "[$traffic] [$memory] [$cpu_temp $cpu_usage]" 
  
  }; export -f kde_resources

  # kde date
  kde_date() {

    date +"[%A] [%B] [%d-%m-%Y] [%H:%M:%S:%3N]"

  }; export -f kde_date

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
    git add . && git commit -m "$message" && git push origin

  }; export -f gd

  # default compile command
  mi() { 

    make &&
    sudo make install 

  }; export -f mi

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

  # start xorg-server
  sx() { 
    
    startx
    
   }; export -f sx

  # python
  py() { 
    
    python "$@"
  
  }; export -f gc


# pacman aliases

  # install a package
  pm() { 
    
    sudo pacman -S "$@"
    
  }; export -f pm

  # system update
  pms() { 
    
    sudo pacman -Syu "$@"
    
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

  # log out
  lo() { 
    # that magic command logs you out of the kde session
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

# start xserver on login

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi