# shellcheck shell=bash

install_discord() {
  install_flatpak "com.discordapp.Discord" "Discord"
}

install_thunderbird() {
  install_apt "thunderbird" "Thunderbird"
}

install_session() {
  print_info "Installing Session..."
  local tmp_file
  tmp_file="/tmp/session-desktop-linux-amd64.deb"

  if wget -O "$tmp_file" "https://github.com/oxen-io/session-desktop/releases/latest/download/session-desktop-linux-amd64.deb"; then
    if sudo apt install -y "$tmp_file"; then
      rm -f "$tmp_file"
      mark_success "Session"
      return 0
    fi
  fi

  rm -f "$tmp_file"
  mark_failure "Session"
  return 1
}

install_libreoffice() {
  install_apt_many "LibreOffice" libreoffice libreoffice-l10n-es
}

install_vlc() {
  install_apt "vlc" "VLC"
}

install_all_applications() {
  install_discord
  install_thunderbird
  install_session
  install_libreoffice
  install_vlc
}
