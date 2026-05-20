# shellcheck shell=bash

detect_docker_repo_codename() {
  local codename="${DISTRO_CODENAME:-}"

  case "$DISTRO" in
    debian|ubuntu)
      if [[ -n "$codename" ]]; then
        echo "$codename"
        return 0
      fi
      ;;
    parrot)
      # Parrot is Debian-based, use a known Docker-supported fallback.
      echo "bookworm"
      return 0
      ;;
  esac

  if [[ -f /etc/debian_version ]]; then
    local major
    major="$(cut -d. -f1 /etc/debian_version)"
    if [[ "$major" == "11" ]]; then
      echo "bullseye"
      return 0
    fi
    echo "bookworm"
    return 0
  fi

  echo "bookworm"
}

install_docker() {
  print_info "Installing Docker..."
  sudo apt install -y ca-certificates curl gnupg lsb-release

  sudo install -m 0755 -d /etc/apt/keyrings
  if [[ ! -f /etc/apt/keyrings/docker.gpg ]]; then
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  fi
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  local docker_codename
  docker_codename="$(detect_docker_repo_codename)"

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $docker_codename stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

  ensure_apt_update

  if sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; then
    sudo usermod -aG docker "$USER"
    mark_success "Docker"
    print_warning "Log out and back in to apply the docker group."
    return 0
  fi

  mark_failure "Docker"
  return 1
}
