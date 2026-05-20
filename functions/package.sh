# shellcheck shell=bash

FLATPAK_READY=0

mark_success() {
  local friendly_name="$1"
  print_success "$friendly_name installed successfully"
  ((INSTALL_COUNT++))
}

mark_failure() {
  local friendly_name="$1"
  print_error "Failed to install $friendly_name"
  FAILED_APPS+=("$friendly_name")
  ((FAILED_COUNT++))
}

is_installed() {
  local package="$1"
  dpkg -s "$package" >/dev/null 2>&1
}

install_apt() {
  local package="$1"
  local friendly_name="$2"

  if is_installed "$package"; then
    print_warning "$friendly_name is already installed"
    return 0
  fi

  print_info "Installing $friendly_name..."
  if sudo apt install -y "$package"; then
    mark_success "$friendly_name"
    return 0
  fi

  mark_failure "$friendly_name"
  return 1
}

install_apt_many() {
  local friendly_name="$1"
  shift
  local packages=("$@")

  print_info "Installing $friendly_name..."
  if sudo apt install -y "${packages[@]}"; then
    mark_success "$friendly_name"
    return 0
  fi

  mark_failure "$friendly_name"
  return 1
}

setup_flatpak() {
  if [[ "$FLATPAK_READY" -eq 1 ]]; then
    return 0
  fi

  if ! command -v flatpak >/dev/null; then
    print_info "Flatpak is not installed. Installing..."
    sudo apt install -y flatpak
  fi

  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  FLATPAK_READY=1
}

install_flatpak() {
  local app_id="$1"
  local friendly_name="$2"

  setup_flatpak
  print_info "Installing $friendly_name (Flatpak)..."
  if flatpak install -y flathub "$app_id"; then
    mark_success "$friendly_name"
    return 0
  fi

  mark_failure "$friendly_name"
  return 1
}

ensure_apt_update() {
  print_info "Updating apt package index..."
  sudo apt update
}

parse_descriptor() {
  local descriptor="$1"
  local default_name="$2"
  local id_var_name="$3"
  local name_var_name="$4"
  local parsed_id
  local parsed_name

  parsed_id="$descriptor"
  parsed_name="$default_name"

  if [[ "$descriptor" == *"|"* ]]; then
    parsed_id="${descriptor%%|*}"
    parsed_name="${descriptor#*|}"
  fi

  printf -v "$id_var_name" '%s' "$parsed_id"
  printf -v "$name_var_name" '%s' "$parsed_name"
}

install_flatpak_from_descriptor() {
  local descriptor="$1"
  local app_id
  local friendly_name

  parse_descriptor "$descriptor" "$descriptor" app_id friendly_name
  install_flatpak "$app_id" "$friendly_name"
}

install_vscode_extension() {
  local descriptor="$1"
  local extension_id
  local friendly_name

  parse_descriptor "$descriptor" "$descriptor" extension_id friendly_name

  if ! command -v code >/dev/null 2>&1; then
    print_warning "VS Code not available. Skipping extension: $friendly_name"
    return 0
  fi

  if code --list-extensions 2>/dev/null | grep -Fxq "$extension_id"; then
    print_warning "Extension $friendly_name is already installed"
    return 0
  fi

  print_info "Installing VS Code extension: $friendly_name"
  if code --install-extension "$extension_id" --force; then
    mark_success "VS Code extension $friendly_name"
    return 0
  fi

  mark_failure "VS Code extension $friendly_name"
  return 1
}
