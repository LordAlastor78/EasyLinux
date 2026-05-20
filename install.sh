#!/bin/bash

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly FUNCTIONS_DIR="$SCRIPT_DIR/functions"
readonly MODULES_DIR="$SCRIPT_DIR/modules"
readonly CONFIG_DIR="$SCRIPT_DIR/config"

source "$CONFIG_DIR/defaults.conf"
source "$CONFIG_DIR/apps.conf"

source "$FUNCTIONS_DIR/ui.sh"
source "$FUNCTIONS_DIR/logging.sh"
source "$FUNCTIONS_DIR/helpers.sh"
source "$FUNCTIONS_DIR/checks.sh"
source "$FUNCTIONS_DIR/package.sh"
source "$FUNCTIONS_DIR/system.sh"

source "$MODULES_DIR/browsers.sh"
source "$MODULES_DIR/applications.sh"
source "$MODULES_DIR/development.sh"
source "$MODULES_DIR/docker.sh"
source "$MODULES_DIR/terminal.sh"
source "$MODULES_DIR/wine.sh"

LOG_DIR="$LOG_ROOT_DEFAULT"
LOG_FILE="$LOG_DIR/install_$(date +%Y%m%d_%H%M%S).log"
INSTALL_COUNT=0
FAILED_COUNT=0
declare -a FAILED_APPS=()

DISTRO="unknown"
VERSION="unknown"
DISTRO_CODENAME=""

trap 'error_trap "$LINENO" "$?"' ERR

show_help() {
  cat <<'EOF'
EasyLinux Installer

Usage:
  ./install.sh [opciones]

Options:
  --all             Install everything directly (no per-category prompts)
  --profile NAME    Run a declarative profile from config/profiles/NAME.conf
  --developer       Developer profile
  --desktop         Desktop profile
  --minimal         Minimal profile
  --vm              VM profile
  --redteam         Red team profile
  --yes             Non-interactive confirmation mode
  --no-update       Skip initial system update
  -h, --help        Show this help
EOF
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --all)
        RUN_ALL=1
        ;;
      --profile)
        shift
        if [[ $# -eq 0 ]]; then
          echo "Missing value for --profile"
          exit 1
        fi
        PROFILE="$1"
        ;;
      --developer)
        PROFILE="developer"
        ;;
      --desktop)
        PROFILE="desktop"
        ;;
      --minimal)
        PROFILE="minimal"
        ;;
      --vm)
        PROFILE="vm"
        ;;
      --redteam)
        PROFILE="redteam"
        ;;
      --yes)
        AUTO_YES=1
        ;;
      --no-update)
        SKIP_UPDATE=1
        ;;
      -h|--help)
        show_help
        exit 0
        ;;
      *)
        echo "Unknown option: $1"
        show_help
        exit 1
        ;;
    esac
    shift
  done
}

menu_browsers() {
  print_header "$CYAN" "BROWSERS"
  echo "  1) Brave Browser"
  echo "  2) LibreWolf"
  echo "  3) Floorp"
  echo "  4) Supremium/Chromium"
  echo "  5) All"
  echo "  0) Skip"
  read -r -p "Option [0-5]: " browser_choice

  case "$browser_choice" in
    1) install_brave ;;
    2) install_librewolf ;;
    3) install_floorp ;;
    4) install_supremium ;;
    5) install_all_browsers ;;
    0) print_info "Skipping browsers" ;;
    *) print_warning "Invalid option" ;;
  esac
}

menu_applications() {
  print_header "$GREEN" "APPLICATIONS"
  echo "  1) Discord"
  echo "  2) Thunderbird"
  echo "  3) Session"
  echo "  4) LibreOffice"
  echo "  5) VLC"
  echo "  6) All"
  echo "  0) Skip"
  read -r -p "Option [0-6]: " app_choice

  case "$app_choice" in
    1) install_discord ;;
    2) install_thunderbird ;;
    3) install_session ;;
    4) install_libreoffice ;;
    5) install_vlc ;;
    6) install_all_applications ;;
    0) print_info "Skipping applications" ;;
    *) print_warning "Invalid option" ;;
  esac
}

menu_development() {
  print_header "$PURPLE" "DEVELOPMENT"
  echo "  1) VS Code"
  echo "  2) Python"
  echo "  3) C++"
  echo "  4) Java"
  echo "  5) Node.js"
  echo "  6) Go"
  echo "  7) Rust"
  echo "  8) Ruby"
  echo "  9) Dart"
  echo "  10) Full development stack"
  echo "  0) Skip"
  read -r -p "Option [0-10]: " dev_choice

  case "$dev_choice" in
    1) install_vscode ;;
    2) install_python ;;
    3) install_cpp ;;
    4) install_java ;;
    5) install_nodejs ;;
    6) install_go ;;
    7) install_rust ;;
    8) install_ruby ;;
    9) install_dart ;;
    10) install_all_development ;;
    0) print_info "Skipping development" ;;
    *) print_warning "Invalid option" ;;
  esac
}

menu_tools() {
  print_header "$YELLOW" "ADDITIONAL TOOLS"
  echo "  1) Git"
  echo "  2) Docker"
  echo "  3) Terminal tools"
  echo "  4) All"
  echo "  0) Skip"
  read -r -p "Option [0-4]: " tools_choice

  case "$tools_choice" in
    1) install_git ;;
    2) install_docker ;;
    3) install_terminal_tools ;;
    4) install_all_terminal ;;
    0) print_info "Skipping tools" ;;
    *) print_warning "Invalid option" ;;
  esac
}

menu_wine() {
  print_header "$RED" "WINDOWS COMPATIBILITY"
  echo "  1) Wine"
  echo "  2) Wine + Winetricks"
  echo "  3) Wine + PlayOnLinux"
  echo "  4) All"
  echo "  0) Skip"
  read -r -p "Option [0-4]: " wine_choice

  case "$wine_choice" in
    1) install_wine ;;
    2) install_wine && install_winetricks ;;
    3) install_wine && install_playonlinux ;;
    4) install_all_wine ;;
    0) print_info "Skipping Wine" ;;
    *) print_warning "Invalid option" ;;
  esac
}

install_all() {
  print_info "Global installation started (without per-category prompts)..."
  install_all_browsers
  install_all_applications
  install_all_development
  install_all_terminal
}

run_profile() {
  local profile_file="$CONFIG_DIR/profiles/${PROFILE}.conf"
  local catalogs_dir="$CONFIG_DIR/catalogs"
  local catalog_name
  local catalog_file
  local profile_step
  local profile_pkg
  local profile_flatpak
  local profile_extension

  if [[ ! -f "$profile_file" ]]; then
    print_error "Profile not found: $PROFILE"
    print_info "Expected path: $profile_file"
    return 1
  fi

  PROFILE_DESCRIPTION=""
  PROFILE_CATALOGS=()
  PROFILE_STEPS=()
  PROFILE_APT_PACKAGES=()
  PROFILE_FLATPAK_APPS=()
  PROFILE_VSCODE_EXTENSIONS=()

  # shellcheck disable=SC1090
  source "$profile_file"

  if [[ "${#PROFILE_CATALOGS[@]}" -eq 0 && "${#PROFILE_STEPS[@]}" -eq 0 && "${#PROFILE_APT_PACKAGES[@]}" -eq 0 && "${#PROFILE_FLATPAK_APPS[@]}" -eq 0 && "${#PROFILE_VSCODE_EXTENSIONS[@]}" -eq 0 ]]; then
    print_error "Profile $PROFILE does not define executable content"
    return 1
  fi

  if [[ -n "$PROFILE_DESCRIPTION" ]]; then
    print_info "Profile: $PROFILE - $PROFILE_DESCRIPTION"
  fi

  for catalog_name in "${PROFILE_CATALOGS[@]}"; do
    CATALOG_DESCRIPTION=""
    CATALOG_STEPS=()
    CATALOG_APT_PACKAGES=()
    CATALOG_FLATPAK_APPS=()
    CATALOG_VSCODE_EXTENSIONS=()

    catalog_file="$catalogs_dir/${catalog_name}.conf"
    if [[ ! -f "$catalog_file" ]]; then
      print_warning "Catalog not found: $catalog_name"
      continue
    fi

    # shellcheck disable=SC1090
    source "$catalog_file"

    if [[ -n "$CATALOG_DESCRIPTION" ]]; then
      print_info "Catalog: $catalog_name - $CATALOG_DESCRIPTION"
    else
      print_info "Catalog: $catalog_name"
    fi

    for profile_step in "${CATALOG_STEPS[@]}"; do
      if ! declare -F "$profile_step" >/dev/null; then
        print_warning "Unknown step in catalog $catalog_name: $profile_step"
        continue
      fi

      print_info "Running catalog step: $profile_step"
      "$profile_step"
    done

    for profile_pkg in "${CATALOG_APT_PACKAGES[@]}"; do
      install_apt "$profile_pkg" "$profile_pkg"
    done

    for profile_flatpak in "${CATALOG_FLATPAK_APPS[@]}"; do
      install_flatpak_from_descriptor "$profile_flatpak"
    done

    for profile_extension in "${CATALOG_VSCODE_EXTENSIONS[@]}"; do
      install_vscode_extension "$profile_extension"
    done
  done

  for profile_step in "${PROFILE_STEPS[@]}"; do
    if ! declare -F "$profile_step" >/dev/null; then
      print_warning "Unknown step in profile $PROFILE: $profile_step"
      continue
    fi

    print_info "Running profile step: $profile_step"
    "$profile_step"
  done

  for profile_pkg in "${PROFILE_APT_PACKAGES[@]}"; do
    install_apt "$profile_pkg" "$profile_pkg"
  done

  for profile_flatpak in "${PROFILE_FLATPAK_APPS[@]}"; do
    install_flatpak_from_descriptor "$profile_flatpak"
  done

  for profile_extension in "${PROFILE_VSCODE_EXTENSIONS[@]}"; do
    install_vscode_extension "$profile_extension"
  done
}

interactive_menu() {
  while true; do
    print_header "$BLUE" "MAIN MENU"
    echo "  1) Browsers"
    echo "  2) Applications"
    echo "  3) Development"
    echo "  4) Additional tools"
    echo "  5) Windows compatibility"
    echo "  6) Install EVERYTHING (without Wine)"
    echo "  0) Exit"
    read -r -p "Option [0-6]: " main_choice

    case "$main_choice" in
      1) menu_browsers ;;
      2) menu_applications ;;
      3) menu_development ;;
      4) menu_tools ;;
      5) menu_wine ;;
      6)
        install_all
        break
        ;;
      0)
        break
        ;;
      *)
        print_warning "Invalid option"
        ;;
    esac

    if ! confirm_default_yes "Do you want to install more components?"; then
      break
    fi
  done
}

main() {
  parse_args "$@"
  init_logging
  show_banner

  print_info "Starting EasyLinux Installer"
  log "===== INSTALLATION START ====="

  check_sudo
  detect_distro

  if ! check_internet; then
    print_error "An internet connection is required to continue"
    exit 1
  fi

  if [[ "$SKIP_UPDATE" -eq 0 ]] && confirm_default_yes "Do you want to update the system before installing?"; then
    update_system
  fi

  if [[ "$RUN_ALL" -eq 1 ]]; then
    install_all
  elif [[ -n "$PROFILE" ]]; then
    print_info "Running profile: $PROFILE"
    run_profile
  else
    interactive_menu
  fi

  post_install_config
  show_summary

  log "===== INSTALLATION END ====="

  if confirm_default_no "Do you want to reboot the system now?"; then
    print_info "Rebooting system..."
    sudo reboot
  fi
}

main "$@"
