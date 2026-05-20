# shellcheck shell=bash

check_sudo() {
  if [[ "$EUID" -eq 0 ]]; then
    print_error "Do not run this script as root. Use your regular user account."
    exit 1
  fi

  if ! sudo -v; then
    print_error "Sudo privileges are required to continue."
    exit 1
  fi

  # Keep sudo alive to avoid expiration during long installations.
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &
}

check_internet() {
  print_info "Checking connectivity to deb.debian.org..."
  if curl -Is https://deb.debian.org >/dev/null; then
    print_success "Internet connection OK"
    return 0
  fi

  print_error "No valid HTTPS/DNS connectivity"
  return 1
}

detect_distro() {
  if [[ -f /etc/os-release ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    DISTRO="$ID"
    VERSION="$VERSION_ID"
    DISTRO_CODENAME="${VERSION_CODENAME:-}"
    print_info "Detected system: $PRETTY_NAME"
    return 0
  fi

  DISTRO="unknown"
  VERSION="unknown"
  DISTRO_CODENAME=""
  print_warning "Unable to detect Linux distribution"
}
