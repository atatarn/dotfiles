#!/usr/bin/env zsh

WIN_SSH_CONFIG_FILE="${WIN_SSH_CONFIG_FILE:-}"

alias admssh="ssh.exe"
alias admscp="scp.exe"

# Parse the file and handle the include directive.
_parse_winssh_config_file() {
  # Enable PCRE matching and handle local options
  setopt localoptions rematchpcre
  unsetopt nomatch

  # Resolve the full path of the input config file
  local config_file_path=$(realpath "$1")

  # Read the file line by line
  cat "$config_file_path" | sed 's/\\/\\\//g' | sed 's/\r$//' | while IFS= read -r line || [[ -n "$line" ]]; do
    # Match lines starting with 'Include'
    if [[ $line =~ ^[Ii]nclude[[:space:]]+(.*) ]] && (( $#match > 0 )); then
      # Split the rest of the line into individual paths
      local include_paths=(${(z)match[1]})

      for raw_path in "${include_paths[@]}"; do
        # Expand ~ and environment variables in the path
        eval "local expanded=\${(e)raw_path}"

        # If path is relative, resolve it relative to the current config file
        if [[ "$expanded" != /* ]]; then
          expanded="$(dirname "$config_file_path")/$expanded"
        fi

        # Expand wildcards (e.g. *.conf) and loop over each matched file
        for include_file_path in $~expanded; do
          if [[ -f "$include_file_path" ]]; then
            # Separate includes with a blank line (for readability)
            echo ""
            # Recursively parse included files
            _parse_config_file "$include_file_path"
          fi
        done
      done
    else
      # Print normal (non-Include) lines
      echo "$line"
    fi
  done
}

_winssh_host_list() {
  local ssh_config host_list

  ssh_config=$(_parse_winssh_config_file $WIN_SSH_CONFIG_FILE)
  ssh_config=$(echo $ssh_config | command grep -v -E "^\s*#[^_]")

  host_list=$(echo $ssh_config | command awk '
    function join(array, start, end, sep, result, i) {
      # https://www.gnu.org/software/gawk/manual/html_node/Join-Function.html
      if (sep == "")
        sep = " "
      else if (sep == SUBSEP) # magic value
        sep = ""
      result = array[start]
      for (i = start + 1; i <= end; i++)
        result = result sep array[i]
      return result
    }

    function parse_line(line) {
      n = split(line, line_array, " ")

      key = line_array[1]
      value = join(line_array, 2, n)

      return key "#-#" value
    }

    function contains_star(str) {
        return index(str, "*") > 0
    }

    function starts_or_ends_with_star(str) {
        start_char = substr(str, 1, 1)
        end_char = substr(str, length(str), 1)

        return start_char == "*" || end_char == "*"
    }

    BEGIN {
      IGNORECASE = 1
      FS="\n"
      RS=""

      host_list = ""
    }
    {
      match_directive = ""

      # Use spaces to ensure the column command maintains the correct number of columns.
      #   - user
      #   - desc_formated

      user = " "
      host_name = ""
      alias = ""
      desc = ""
      desc_formated = " "

      for (line_num = 1; line_num <= NF; ++line_num) {
        line = parse_line($line_num)

        split(line, tmp, "#-#")

        key = tolower(tmp[1])
        value = tmp[2]


        if (key == "match") { match_directive = value }

        if (key == "host") { aliases = value }
        if (key == "user") { user = value }
        if (key == "hostname") { host_name = value }
        if (key == "#_desc") { desc = value }
        
      }


      split(aliases, alias_list, " ")
      for (i in alias_list) {
        alias = alias_list[i]

        if (!host_name && alias ) {
          host_name = alias
        }

        if (desc) {
          desc_formated = sprintf("[\033[00;34m%s\033[0m]", desc)
        }

        if ((host_name && !starts_or_ends_with_star(host_name)) && (alias && !starts_or_ends_with_star(alias)) && !match_directive) {
          host = sprintf("%s|->|%s|%s|%s\n", alias, host_name, user, desc_formated)
          host_list = host_list host
        }
      }
    }
    END {
      print host_list
    }
  ')

  for arg in "$@"; do
    case $arg in
    -*) shift;;
    *) break;;
    esac
  done

  if [[ -n "$1" ]]; then
    host_list=$(command grep -i "$1" <<< "$host_list")
  fi
  host_list=$(printf "%s\n" "$host_list" | command sort -u)

  echo $host_list
}


_fzf_winssh_list_generator() {
  local header host_list

  if [ -n "$1" ]; then
    host_list="$1"
  else
    host_list=$(_winssh_host_list)
  fi

  header="
Alias|->|Hostname|User|Desc
─────|──|────────|────|────
"

  host_list="${header}\n${host_list}"

  echo $host_list | command column -t -s '|'
}

_winssh_set_lbuffer() {
  local result selected_host connect_cmd is_fzf_result
  cmd="$1"
  result="$2"
  is_fzf_result="$3"

  if [ "$is_fzf_result" = false ] ; then
    result=$(cut -f 1 -d "|" <<< ${result})
  fi

  selected_host=$(cut -f 1 -d " " <<< ${result})
  connect_cmd="$cmd ${selected_host}"

  LBUFFER="$connect_cmd"
}

fzf_complete_winssh() {
  local tokens cmd result key selection
  setopt localoptions noshwordsplit noksh_arrays noposixbuiltins

  tokens=(${(z)LBUFFER})
  cmd=${tokens[1]}

  if [[ "$cmd" == "admssh" || "$cmd" == "admscp" ]]; then
    result=$(_winssh_host_list ${tokens[2, -1]})
    fuzzy_input="${LBUFFER#"$tokens[1] "}"

    if [ -z "$result" ]; then
      # When host parameters exist, don't fall back to default completion to avoid slow hosts enumeration
      if [[ -z "${tokens[2]}" || "${tokens[-1]}" == -* ]]; then
        zle ${fzf_ssh_default_completion:-expand-or-complete}
      fi
      return
    fi

    if [ $(echo $result | wc -l) -eq 1 ]; then
      _winssh_set_lbuffer $cmd $result false
      zle reset-prompt
      # zle redisplay
      return
    fi

    result=$(_fzf_winssh_list_generator $result | fzf \
      --height 40% \
      --ansi \
      --border \
      --cycle \
      --info=inline \
      --header-lines=2 \
      --reverse \
      --prompt='SSH Remote > ' \
      --query=$fuzzy_input \
      --no-separator \
      --bind 'shift-tab:up,tab:down,bspace:backward-delete-char/eof' \
      --preview 'ssh.exe -T -G $(cut -f 1 -d " " <<< {}) | grep -i -E "^User |^HostName |^Port |^ControlMaster |^ForwardAgent |^LocalForward |^IdentityFile |^RemoteForward |^ProxyCommand |^ProxyJump |^pkcs11provider " | column -t' \
      --preview-window=right:40% \
      --expect=alt-enter,enter
    )

    if [ -n "$result" ]; then
      key=${result%%$'\n'*}
      if [[ "$key" == "$result" ]]; then
        selection="$result"
        key=""
      else
        selection=${result#*$'\n'}
      fi

      if [ -n "$selection" ]; then
        _winssh_set_lbuffer $cmd "$selection" true
        if [[ "$key" == "alt-enter" ]]; then
          zle reset-prompt
        elif [[ "$cmd" == "admssh" ]]; then
          zle accept-line
        fi
      fi
    fi

    # Only reset prompt if not already done for alt-enter
    if [[ "$key" != "alt-enter" ]]; then
      zle reset-prompt
      # zle redisplay
    fi

  fi
}


fzf_or_default_complete() {
  local tokens cmd
  tokens=(${(z)LBUFFER})
  cmd=${tokens[1]}

  if [[ "$cmd" == admssh || "$cmd" == admscp ]]; then
    fzf_complete_winssh
  else
    zle expand-or-complete
  fi
}

zle -N fzf_or_default_complete
bindkey '^I' fzf_or_default_complete

# zle -N fzf_complete_winssh
# bindkey '^I' fzf_complete_winssh


# vim: set ft=zsh sw=2 ts=2 et