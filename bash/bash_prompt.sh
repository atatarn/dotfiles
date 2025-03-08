# color helpers
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[1;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[1;34m\]"
     PURPLE="\[\033[0;35m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"

#declare -i P_L
P_L=0

function parse_git_branch() {
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function set_git_branch() {
  local branch=$(parse_git_branch)
  if [ "$branch" != "" ]; then
    local branch_str="(git: $branch) ";
    P_GIT_BRANCH="${YELLOW}$branch_str${COLOR_NONE}";
    let P_L+=${#branch_str}
  else
    P_GIT_BRANCH=""
    let P_L+=${#branch_str}	  
  fi
}

function set_py_virtualenv() {
  local venv_str="[py: Global] "
  if [ ! -z $VIRTUAL_ENV ]; then
    venv_str="[py: $(basename $VIRTUAL_ENV)] "
  fi
  P_PYTHON_VIRTUALENV="${PURPLE}${venv_str}${COLOR_NONE}"
  let P_L+=${#venv_str}
}

function set_chroot() {
  P_CHROOT="${debian_chroot:+($debian_chroot)}"
  let P_L+=${#P_CHROOT}
}

function set_user_host() {
  local uh="\u "
  local uh_str="${uh@P}"
  #local uh_str="\u@\h "
  P_USER_HOST="${LIGHT_GREEN}${uh_str}${COLOR_NONE}"
  let P_L+=${#uh_str}
}

function set_cwd() {
  local w="\w "
  local w_str="${w@P}"
  P_CWD="${BLUE}${w_str}${COLOR_NONE}"
  let P_L+=${#w_str}
}

function set_prompt_symbol() {
  local prompt="$ "
  P_PROMPT_SYMBOL="${BLUE}${prompt}${COLOR_NONE}"
  let P_L+=${#prompt}
}

function set_colored_prompt() {
  # build parts
  set_chroot
  set_user_host
  set_cwd
  set_prompt_symbol
  set_git_branch
  set_py_virtualenv

  # xterm title hack
  # https://www.gnu.org/software/screen/manual/html_node/Control-Sequences.html
  # this needs to go first to restore terminal tab/window name
  #magic="\[\e]0;\u@\h: \w\a\]"
  magic="\[\e]0;\u \w\a\]"

  #PS1="${magic}${P_CHROOT}${P_USER_HOST}${P_CWD}${P_PYTHON_VIRTUALENV}${P_GIT_BRANCH}${P_PROMPT_SYMBOL} "

  PS1="${magic}${P_CHROOT}\n${P_USER_HOST}${P_CWD}${P_PYTHON_VIRTUALENV}${P_GIT_BRANCH}${P_PROMPT_SYMBOL}"

  local term_limit=$(tput cols)
  local ps_limit=$(( $term_limit / 2 ))
  if [ $P_L -ge $(( $(tput cols) / 2 )) ]; then
    PS1="${magic}${P_CHROOT}\n"
    PS1="${PS1}${P_PYTHON_VIRTUALENV}${P_GIT_BRANCH}\n"
    PS1="${PS1}${P_USER_HOST}${P_CWD}${P_PROMPT_SYMBOL}"
  fi

}

PROMPT_COMMAND=set_colored_prompt
unset P_L
unset P_GIT_BRANCH P_PYTHON_VIRTUALENV P_CHROOT P_USER_HOST P_CWD P_PROMPT_SYMBOL
