# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

DOTBASH="${HOME}/dotfiles/bash";

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=999999
HISTIGNORE=""
HISTCONTROL=""

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# local sources, if any
if [ -d ~/.config/bashrc.d ]; then
	for f in ~/.config/bashrc.d/*.sh; do source $f; done
fi

# default sources
for f in "${DOTBASH}/rc.d/*.sh"; do source $f; done


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

# python's requests to trust system CAs
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt;

# dotnet?
export DOTNET_CLI_TELEMETRY_OPTOUT=1;

