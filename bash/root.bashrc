# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022
magic="\[\e]0;\u@\h: \w\a\]"
PS1="${magic}${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\h\[\033[00m\] \[\033[01;34m\]\w \$\[\e[00m\] "

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "`dircolors`"
alias ls='ls --color'
alias ll='ls --color -lah'
# alias l='ls $LS_OPTIONS -lA'
#
