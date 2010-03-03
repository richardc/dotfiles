# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

export WIRESHARK_APP_DIR="$HOME/Applications/Wireshark.app"

export EDITOR=vim

# my path, not yours
export PATH="$HOME/.gem/ruby/1.8/bin:$HOME/bin:$HOME/bin/wireshark:/opt/ipc/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/git/bin"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

prompt_host=$( hostname | awk -F. '{print $1}' )
if [ -f /opt/ipc/etc/realname  ]; then
  prompt_host="$prompt_host|$( cat /opt/ipc/etc/realname )"
fi

PS1='\033[1m[\D{%Y-%m-%d %H:%M:%S}] \u@${prompt_host}:\w\033[0m\n\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|screen)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# append history
shopt -s histappend
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# fuck you and your auto-suggesting ways
unset command_not_found_handle

# xdg-open(1) on Linux, open(1) on OSX
[ $( uname ) == "Linux" ] && alias open=xdg-open

alias vi=vim

return # one day we may want programmable completion, but not soon

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
