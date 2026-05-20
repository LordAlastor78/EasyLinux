# shellcheck shell=bash

install_vscode() {
  print_info "Installing Visual Studio Code..."
  sudo install -m 0755 -d /usr/share/keyrings

  if [[ ! -f /usr/share/keyrings/packages.microsoft.gpg ]]; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/packages.microsoft.gpg >/dev/null
  fi

  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
    | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null

  ensure_apt_update
  install_apt "code" "Visual Studio Code"
}

install_python() {
  install_apt_many "Python" python3 python3-pip python3-venv python3-dev
}

install_cpp() {
  install_apt_many "C++ toolchain" build-essential gdb cmake
}

install_java() {
  local java_choice
  echo ""
  echo "Select Java:"
  echo "  1) Java 17 LTS"
  echo "  2) Java 21 LTS"
  echo "  3) Both"
  read -r -p "Option [1-3]: " java_choice

  case "$java_choice" in
    1) install_apt "openjdk-17-jdk" "Java 17" ;;
    2) install_apt "openjdk-21-jdk" "Java 21" ;;
    3) install_apt_many "Java 17 and 21" openjdk-17-jdk openjdk-21-jdk ;;
    *)
      print_warning "Invalid option. Installing Java 21."
      install_apt "openjdk-21-jdk" "Java 21"
      ;;
  esac
}

install_nodejs() {
  print_info "Installing Node.js (signed repository)..."

  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
    | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
  sudo chmod a+r /etc/apt/keyrings/nodesource.gpg

  local node_major="22"
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${node_major}.x nodistro main" \
    | sudo tee /etc/apt/sources.list.d/nodesource.list >/dev/null

  ensure_apt_update
  install_apt "nodejs" "Node.js"
}

install_go() {
  install_apt "golang-go" "Go"
}

install_rust() {
  print_info "Installing Rust..."
  sudo apt install -y build-essential curl

  if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; then
    # shellcheck disable=SC1090
    source "$HOME/.cargo/env"
    mark_success "Rust"
    return 0
  fi

  mark_failure "Rust"
  return 1
}

install_ruby() {
  install_apt_many "Ruby" ruby-full ruby-dev
}

install_dart() {
  print_info "Installing Dart..."
  sudo apt install -y apt-transport-https wget
  sudo install -m 0755 -d /usr/share/keyrings

  if [[ ! -f /usr/share/keyrings/dart.gpg ]]; then
    wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
  fi

  echo "deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main" \
    | sudo tee /etc/apt/sources.list.d/dart_stable.list >/dev/null

  ensure_apt_update
  install_apt "dart" "Dart"
}

install_all_development() {
  install_vscode
  install_python
  install_cpp
  install_java
  install_nodejs
  install_go
  install_rust
  install_ruby
  install_dart
}
