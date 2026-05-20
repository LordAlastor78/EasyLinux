# shellcheck shell=bash

update_system() {
  print_header "$PURPLE" "SYSTEM UPDATE"

  print_info "Updating package list..."
  sudo apt update

  print_info "Upgrading system..."
  sudo apt upgrade -y

  print_info "Cleaning unnecessary packages..."
  sudo apt autoremove -y
  sudo apt autoclean

  print_success "System updated"
}

post_install_config() {
  print_header "$CYAN" "POST-INSTALL"

  if command -v git >/dev/null; then
    print_info "Applying base Git configuration"
    git config --global init.defaultBranch main || true
    git config --global pull.rebase false || true
    git config --global credential.helper store || true
  fi
}
