# shellcheck shell=bash

install_git() {
  if install_apt_many "Git" git git-gui gitk; then
    if confirm_default_no "Do you want to configure Git now?"; then
      read -r -p "Enter your name: " git_name
      read -r -p "Enter your email: " git_email
      git config --global user.name "$git_name"
      git config --global user.email "$git_email"
      git config --global init.defaultBranch main
      print_success "Git configured"
    fi
    return 0
  fi

  return 1
}

install_terminal_tools() {
  install_apt_many "Terminal tools" "${TERMINAL_TOOLS[@]}"
}

install_all_terminal() {
  install_git
  install_docker
  install_terminal_tools
}
