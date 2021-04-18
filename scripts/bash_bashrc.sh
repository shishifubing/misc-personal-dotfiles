#!/usr/bin/env bash

source ~/Repositories/dot-files/scripts/bash_functions.sh
source ~/Repositories/dot-files/scripts/bash_preexec.sh
# default stuff 

  # if not running interactively, don't do anything
    case $- in
        *i*) ;;
          *) return;;
    esac

  # check the window size after each command and, if necessary,
  # update the values of LINES and COLUMNS.
    shopt -s checkwinsize

  # if set, the pattern "**" used in a pathname expansion context will
  # match all files and zero or more directories and subdirectories.
    #shopt -s globstar

  # make less more friendly for non-text input files, see lesspipe(1) 

    [[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"
    
  # set variable identifying the chroot you work in (used in the prompt below)

    if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
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
    if [[ -n "$force_color_prompt" ]]; then
      if [[ -x /usr/bin/tput ]] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
      else
        color_prompt=
      fi
    fi
    if [[ "$color_prompt" = yes ]]; then
      PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    else
      PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    fi
    unset color_prompt force_color_prompt
    
  # if this is an xterm set the title to user@host:dir
    
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

# variables

  # random variables

    export LC_ALL="en_US.UTF-8" # all locales are overwritten
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01' # colored GCC warnings and errors

  # bash history

    export HISTFILE=~/.bash_history # bash history
    export HISTCONTROL= #"ignoreboth:erasedups" # don't put duplicate lines or lines starting with space in the bash history.
    export HISTFILESIZE= # unlimited bash history (file size)
    export HISTSIZE= # unlimited bash history (lines) 
    shopt -s histappend # append to the history file, don't overwrite it
    # flushes the command to the history file immediately (otherwise, this would happen only when the shell exits
    #export PROMPT_COMMAND='
    #  history -a;
    #  printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"
    #'
    #export PROMPT_COMMAND='echo -ne "\033]0;$(get_window_title)\007"'
    export PROMPT_COMMAND='set_window_title $(get_window_title)'

# bindings

  #bind -x '"\e[A": history_item' # up arrow
  #bind -x '"\e[B": history_item' # down arrow
  setxkbmap -option caps:escape # remaps caps lock to escape

# start stuff when a shell starts
  
  # start xserver on login
  if [[ -z "${DISPLAY}" ]] && [[ "${XDG_VTNR}" -eq 1 ]]; then
    echo "Start xorg-server? y/n"
    read -r answer
    if [[ "$answer" != "n" ]] && [[ "$answer" != "N" ]]; then
      exec startx
    fi
  fi
