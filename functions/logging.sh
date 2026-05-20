# shellcheck shell=bash

create_log_dir() {
  mkdir -p "$LOG_DIR"
}

init_logging() {
  create_log_dir
  exec > >(tee -a "$LOG_FILE")
  exec 2>&1
}

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

print_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
  log "INFO: $1"
}

print_success() {
  echo -e "${GREEN}[OK]${NC} $1"
  log "SUCCESS: $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
  log "ERROR: $1"
}

print_warning() {
  echo -e "${YELLOW}[WARN]${NC} $1"
  log "WARNING: $1"
}

show_summary() {
  echo ""
  print_header "$GREEN" "INSTALL SUMMARY"
  echo "Installed successfully: $INSTALL_COUNT"
  echo "Failed: $FAILED_COUNT"
  echo ""

  if [[ "$FAILED_COUNT" -gt 0 ]]; then
    echo "Applications with errors:"
    for app in "${FAILED_APPS[@]}"; do
      echo "  - $app"
    done
    echo ""
  fi

  echo "Log: $LOG_FILE"
}
