alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

alias pip='noglob pip'

# git
alias gst='git status'
# alias gaa='git add -A'
alias gc='git commit'
alias gcm='git checkout main'
alias gd='git diff'
alias gdc='git diff --cached'
# [c]heck [o]ut
alias co='git checkout'
# [f]uzzy check[o]ut
fo() {
  git branch --no-color --sort=-committerdate --format='%(refname:short)' | fzf --header 'git checkout' | xargs git checkout
}
# [p]ull request check[o]ut
#po() {
#  gh pr list --author "@me" | fzf --header 'checkout PR' | awk '{print $(NF-5)}' | xargs git checkout
#}
alias gp='git push'
alias gpf='git push --force'
#alias pu='git pull'
#alias pur='git pull --rebase'
#alias fe='git fetch'
#alias re='git rebase'
#alias lr='git l -30'
#alias cdr='cd $(git rev-parse --show-toplevel)' # cd to git Root
#alias hs='git rev-parse --short HEAD'
#alias hm='git log --format=%B -n 1 HEAD'

