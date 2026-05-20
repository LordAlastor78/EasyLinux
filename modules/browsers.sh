# shellcheck shell=bash

install_brave() {
  print_info "Installing Brave Browser..."
  sudo install -m 0755 -d /usr/share/keyrings
  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
    https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" \
    | sudo tee /etc/apt/sources.list.d/brave-browser-release.list >/dev/null

  ensure_apt_update
  install_apt "brave-browser" "Brave Browser"
}

install_librewolf() {
  print_info "Installing LibreWolf..."
  sudo apt install -y wget gnupg lsb-release apt-transport-https ca-certificates

  local codename
  codename="$(lsb_release -cs)"

  sudo install -m 0755 -d /usr/share/keyrings
  if [[ ! -f /usr/share/keyrings/librewolf.gpg ]]; then
    wget -qO- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg
  fi

  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/librewolf.gpg] http://deb.librewolf.net $codename main" \
    | sudo tee /etc/apt/sources.list.d/librewolf.list >/dev/null

  ensure_apt_update
  install_apt "librewolf" "LibreWolf"
}

install_floorp() {
  install_flatpak "one.ablaze.floorp" "Floorp"
}

install_supremium() {
  print_info "Supremium does not have a stable apt channel. Using Chromium instead."
  install_apt "chromium" "Chromium (Supremium alternative)"
}

install_all_browsers() {
  install_brave
  install_librewolf
  install_floorp
  install_supremium
}
