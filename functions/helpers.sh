# shellcheck shell=bash

error_trap() {
  local line="$1"
  local exit_code="$2"
  print_error "Error en linea $line (codigo $exit_code)"
}

confirm_default_yes() {
  local prompt="$1"

  if [[ "${AUTO_YES:-0}" -eq 1 ]]; then
    return 0
  fi

  read -r -p "$prompt [S/n]: " answer
  [[ ! "$answer" =~ ^[Nn]$ ]]
}

confirm_default_no() {
  local prompt="$1"

  if [[ "${AUTO_YES:-0}" -eq 1 ]]; then
    return 0
  fi

  read -r -p "$prompt [s/N]: " answer
  [[ "$answer" =~ ^[Ss]$ ]]
}
