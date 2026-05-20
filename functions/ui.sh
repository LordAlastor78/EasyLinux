# shellcheck shell=bash

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'
readonly BOLD='\033[1m'

show_banner() {
  clear
  echo -e "${CYAN}${BOLD}"
  echo "==============================================================="
  echo "                      EASY LINUX INSTALLER                     "
  echo "                 Automated Linux bootstrap setup               "
  echo "==============================================================="
  echo -e "${NC}"
}

print_header() {
  local color="$1"
  local title="$2"
  echo ""
  echo -e "${color}${BOLD}===============================================================${NC}"
  echo -e "${color}${BOLD}  $title${NC}"
  echo -e "${color}${BOLD}===============================================================${NC}"
}
