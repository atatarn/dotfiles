if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# for envs where external proxy exists
alias sshp="ssh -o ProxyCommand=\"nc -X connect -x ${ext_proxy_str} %h %p\""
alias scpp="scp -o ProxyCommand=\"nc -X connect -x ${ext_proxy_str} %h %p\""

