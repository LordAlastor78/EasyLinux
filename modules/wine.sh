# shellcheck shell=bash

show_wine_warning() {
  print_header "$RED" "WINDOWS COMPATIBILITY (NOT RECOMMENDED)"
  echo "- It can cause system instability"
  echo "- Lower performance than native apps"
  echo "- Higher resource usage"
  echo ""

  confirm_default_no "Do you want to continue with Wine?"
}

install_wine() {
  if ! show_wine_warning; then
    print_info "Wine installation canceled"
    return 1
  fi

  print_info "Installing Wine..."
  sudo dpkg --add-architecture i386
  ensure_apt_update

  if sudo apt install -y wine wine32 wine64 libwine libwine:i386 fonts-wine; then
    mark_success "Wine"
    return 0
  fi

  mark_failure "Wine"
  return 1
}

install_winetricks() {
  install_apt "winetricks" "Winetricks"
}

install_playonlinux() {
  install_apt "playonlinux" "PlayOnLinux"
}

install_all_wine() {
  if install_wine; then
    install_winetricks
    install_playonlinux
  fi
}
