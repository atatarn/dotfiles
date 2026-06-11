#!/usr/bin/env zsh

compdef -d psql

_psql_fzf_widget() {
  local service_file="${PGSERVICEFILE:-$HOME/.pg_service.conf}"
  [[ ! -f "$service_file" ]] && { zle redisplay; return; }

  local selected
  selected=$(
    grep -oP '(?<=\[)[^\]]+' "$service_file" \
    | fzf --height=60% --reverse --border \
          --prompt="psql service> " \
          --exit-0 \
          --preview="awk '/^\[{}\]/{f=1;next} f && /^\[/{exit} f' $service_file" \
          --preview-window=right:40%:wrap
  )

  [[ -z "$selected" ]] && { zle redisplay; return; }

  LBUFFER="psql service=$selected"
  RBUFFER=""
  zle redisplay
}

zle -N _psql_fzf_widget

_psql_tab_handler() {
  local cmd="${${(z)BUFFER}[1]}"
  if [[ "$cmd" == "psql" ]] && [[ "$BUFFER" != *service=* ]]; then
    _psql_fzf_widget
  else
    zle expand-or-complete
  fi
}

zle -N _psql_tab_handler
bindkey '^I' _psql_tab_handler