#!/bin/bash

################################################################################
# EasyLinux - Script de Configuración Automática
# Versión: 2.0
# Fecha: Marzo 2026
# Descripción: Instalación automática de aplicaciones para sistemas Linux
################################################################################

# Colores para la interfaz
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color
readonly BOLD='\033[1m'

# Variables globales
LOG_DIR="$HOME/.easylinux/logs"
LOG_FILE="$LOG_DIR/install_$(date +%Y%m%d_%H%M%S).log"
INSTALL_COUNT=0
FAILED_COUNT=0
declare -a FAILED_APPS

################################################################################
# Funciones Auxiliares
################################################################################

# Crear directorio de logs
create_log_dir() {
    mkdir -p "$LOG_DIR"
}

# Función de logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Mostrar banner
show_banner() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                                                                ║"
    echo "║                    🐧 EASY LINUX INSTALLER 🐧                  ║"
    echo "║                                                                ║"
    echo "║         Configuración automática para tu nuevo sistema        ║"
    echo "║                                                                ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Mostrar mensaje con formato
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
    log "INFO: $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
    log "SUCCESS: $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
    log "ERROR: $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
    log "WARNING: $1"
}

# Barra de progreso
show_progress() {
    local current=$1
    local total=$2
    local percent=$((current * 100 / total))
    local filled=$((percent / 2))
    local empty=$((50 - filled))
    
    printf "\r${CYAN}Progreso: [${GREEN}"
    printf "%${filled}s" | tr ' ' '█'
    printf "${NC}"
    printf "%${empty}s" | tr ' ' '░'
    printf "${CYAN}] ${percent}%%${NC}"
}

################################################################################
# Verificaciones Iniciales
################################################################################

# Verificar si el script se ejecuta con privilegios
check_sudo() {
    if [ "$EUID" -eq 0 ]; then
        print_error "No ejecutes este script como root. Úsalo con tu usuario normal."
        print_info "El script solicitará permisos sudo cuando sea necesario."
        exit 1
    fi
    
    if ! sudo -v; then
        print_error "Se requieren permisos sudo para continuar."
        exit 1
    fi
    
    # Mantener sudo activo
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done 2>/dev/null &
}

# Verificar conexión a Internet
check_internet() {
    print_info "Verificando conexión a Internet..."
    if ping -c 1 8.8.8.8 &> /dev/null; then
        print_success "Conexión a Internet establecida"
        return 0
    else
        print_error "No se detectó conexión a Internet"
        return 1
    fi
}

# Detectar distribución
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        VERSION=$VERSION_ID
        print_info "Sistema detectado: $PRETTY_NAME"
        log "Distribución: $DISTRO $VERSION"
    else
        print_warning "No se pudo detectar la distribución"
        DISTRO="unknown"
    fi
}

################################################################################
# Actualización del Sistema
################################################################################

update_system() {
    echo ""
    echo -e "${PURPLE}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}${BOLD}     ACTUALIZACIÓN DEL SISTEMA${NC}"
    echo -e "${PURPLE}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    print_info "Actualizando lista de paquetes..."
    if sudo apt update 2>&1 | tee -a "$LOG_FILE"; then
        print_success "Lista de paquetes actualizada"
    else
        print_error "Error al actualizar la lista de paquetes"
        return 1
    fi
    
    echo ""
    print_info "Actualizando sistema..."
    if sudo apt upgrade -y 2>&1 | tee -a "$LOG_FILE"; then
        print_success "Sistema actualizado correctamente"
    else
        print_error "Error al actualizar el sistema"
        return 1
    fi
    
    echo ""
    print_info "Limpiando paquetes innecesarios..."
    sudo apt autoremove -y &>> "$LOG_FILE"
    sudo apt autoclean &>> "$LOG_FILE"
    print_success "Limpieza completada"
    
    return 0
}

################################################################################
# Funciones de Instalación - Navegadores
################################################################################

install_brave() {
    print_info "Instalando Brave Browser..."
    
    sudo apt install -y curl &>> "$LOG_FILE"
    
    if ! [ -f /usr/share/keyrings/brave-browser-archive-keyring.gpg ]; then
        sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
            https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg &>> "$LOG_FILE"
    fi
    
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" \
        | sudo tee /etc/apt/sources.list.d/brave-browser-release.list &>> "$LOG_FILE"
    
    sudo apt update &>> "$LOG_FILE"
    
    if sudo apt install -y brave-browser &>> "$LOG_FILE"; then
        print_success "Brave Browser instalado correctamente"
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar Brave Browser"
        FAILED_APPS+=("Brave Browser")
        ((FAILED_COUNT++))
        return 1
    fi
}

install_librewolf() {
    print_info "Instalando LibreWolf..."
    
    sudo apt install -y wget gnupg lsb-release apt-transport-https ca-certificates &>> "$LOG_FILE"
    
    distro=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
    codename=$(lsb_release -cs)
    
    if ! [ -f /usr/share/keyrings/librewolf.gpg ]; then
        wget -qO- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg &>> "$LOG_FILE"
    fi
    
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/librewolf.gpg] http://deb.librewolf.net $codename main" \
        | sudo tee /etc/apt/sources.list.d/librewolf.list &>> "$LOG_FILE"
    
    sudo apt update &>> "$LOG_FILE"
    
    if sudo apt install -y librewolf &>> "$LOG_FILE"; then
        print_success "LibreWolf instalado correctamente"
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar LibreWolf"
        FAILED_APPS+=("LibreWolf")
        ((FAILED_COUNT++))
        return 1
    fi
}

install_floorp() {
    print_info "Instalando Floorp..."
    
    # Floorp se instala mejor como Flatpak o descarga directa
    if command -v flatpak &> /dev/null; then
        if flatpak install -y flathub one.ablaze.floorp &>> "$LOG_FILE"; then
            print_success "Floorp instalado correctamente"
            ((INSTALL_COUNT++))
            return 0
        fi
    else
        # Instalar Flatpak primero
        print_info "Instalando Flatpak..."
        sudo apt install -y flatpak &>> "$LOG_FILE"
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &>> "$LOG_FILE"
        
        if flatpak install -y flathub one.ablaze.floorp &>> "$LOG_FILE"; then
            print_success "Floorp instalado correctamente"
            ((INSTALL_COUNT++))
            return 0
        fi
    fi
    
    print_error "Error al instalar Floorp"
    FAILED_APPS+=("Floorp")
    ((FAILED_COUNT++))
    return 1
}

install_supremium() {
    print_info "Instalando Supremium..."
    
    # Supremium puede no estar fácilmente disponible, intentar con Flatpak/Snap
    if command -v flatpak &> /dev/null; then
        if flatpak install -y flathub com.github.Eloston.UngoogledChromium &>> "$LOG_FILE"; then
            print_success "Chromium (alternativa) instalado correctamente"
            ((INSTALL_COUNT++))
            return 0
        fi
    fi
    
    # Alternativa: instalar Chromium estándar
    if sudo apt install -y chromium &>> "$LOG_FILE"; then
        print_success "Chromium instalado correctamente (alternativa a Supremium)"
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar Supremium/Chromium"
        FAILED_APPS+=("Supremium")
        ((FAILED_COUNT++))
        return 1
    fi
}

################################################################################
# Funciones de Instalación - Aplicaciones
################################################################################

install_discord() {
    print_info "Instalando Discord..."
    
    if command -v flatpak &> /dev/null; then
        if flatpak install -y flathub com.discordapp.Discord &>> "$LOG_FILE"; then
            print_success "Discord instalado correctamente"
            ((INSTALL_COUNT++))
            return 0
        fi
    else
        # Instalar via descarga directa
        cd /tmp
        wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb" &>> "$LOG_FILE"
        if sudo apt install -y ./discord.deb &>> "$LOG_FILE"; then
            rm -f discord.deb
            print_success "Discord instalado correctamente"
            ((INSTALL_COUNT++))
            return 0
        fi
        rm -f discord.deb
    fi
    
    print_error "Error al instalar Discord"
    FAILED_APPS+=("Discord")
    ((FAILED_COUNT++))
    return 1
}

install_thunderbird() {
    print_info "Instalando Thunderbird..."
    
    if sudo apt install -y thunderbird &>> "$LOG_FILE"; then
        print_success "Thunderbird instalado correctamente"
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar Thunderbird"
        FAILED_APPS+=("Thunderbird")
        ((FAILED_COUNT++))
        return 1
    fi
}

install_session() {
    print_info "Instalando Session..."
    
    cd /tmp
    # Obtener la última versión de Session
    if wget -O session.deb "https://github.com/oxen-io/session-desktop/releases/latest/download/session-desktop-linux-amd64.deb" &>> "$LOG_FILE"; then
        if sudo apt install -y ./session.deb &>> "$LOG_FILE"; then
            rm -f session.deb
            print_success "Session instalado correctamente"
            ((INSTALL_COUNT++))
            return 0
        fi
        rm -f session.deb
    fi
    
    print_error "Error al instalar Session"
    FAILED_APPS+=("Session")
    ((FAILED_COUNT++))
    return 1
}

install_libreoffice() {
    print_info "Instalando LibreOffice..."
    
    if sudo apt install -y libreoffice libreoffice-l10n-es &>> "$LOG_FILE"; then
        print_success "LibreOffice instalado correctamente"
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar LibreOffice"
        FAILED_APPS+=("LibreOffice")
        ((FAILED_COUNT++))
        return 1
    fi
}

################################################################################
# Funciones de Instalación - Desarrollo
################################################################################

install_vscode() {
    print_info "Instalando Visual Studio Code..."
    
    sudo apt install -y wget gpg &>> "$LOG_FILE"
    
    if ! [ -f /usr/share/keyrings/packages.microsoft.gpg ]; then
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -D -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/packages.microsoft.gpg
        rm packages.microsoft.gpg
    fi
    
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
        | sudo tee /etc/apt/sources.list.d/vscode.list &>> "$LOG_FILE"
    
    sudo apt update &>> "$LOG_FILE"
    
    if sudo apt install -y code &>> "$LOG_FILE"; then
        print_success "Visual Studio Code instalado correctamente"
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar Visual Studio Code"
        FAILED_APPS+=("VS Code")
        ((FAILED_COUNT++))
        return 1
    fi
}

install_python() {
    print_info "Instalando Python..."
    
    if sudo apt install -y python3 python3-pip python3-venv python3-dev &>> "$LOG_FILE"; then
        print_success "Python instalado correctamente"
        python3 --version | tee -a "$LOG_FILE"
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar Python"
        FAILED_APPS+=("Python")
        ((FAILED_COUNT++))
        return 1
    fi
}

install_cpp() {
    print_info "Instalando C++ (g++/gcc)..."
    
    if sudo apt install -y build-essential gdb cmake &>> "$LOG_FILE"; then
        print_success "C++ instalado correctamente"
        g++ --version | head -n1 | tee -a "$LOG_FILE"
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar C++"
        FAILED_APPS+=("C++")
        ((FAILED_COUNT++))
        return 1
    fi
}

install_java() {
    echo ""
    echo -e "${YELLOW}Selecciona la versión de Java a instalar:${NC}"
    echo "  1) Java 17 LTS"
    echo "  2) Java 21 LTS"
    echo "  3) Java 25 (última versión)"
    echo "  4) Todas las versiones"
    echo ""
    read -p "Opción [1-4]: " java_choice
    
    case $java_choice in
        1)
            print_info "Instalando Java 17 LTS..."
            sudo apt install -y openjdk-17-jdk &>> "$LOG_FILE"
            ;;
        2)
            print_info "Instalando Java 21 LTS..."
            sudo apt install -y openjdk-21-jdk &>> "$LOG_FILE"
            ;;
        3)
            print_info "Instalando Java 25..."
            # Java 25 podría requerir repositorio adicional
            sudo apt install -y openjdk-21-jdk &>> "$LOG_FILE"
            print_warning "Instalado Java 21 (Java 25 aún no disponible en repos estándar)"
            ;;
        4)
            print_info "Instalando todas las versiones de Java..."
            sudo apt install -y openjdk-17-jdk openjdk-21-jdk &>> "$LOG_FILE"
            ;;
        *)
            print_warning "Opción inválida. Instalando Java 21 LTS por defecto..."
            sudo apt install -y openjdk-21-jdk &>> "$LOG_FILE"
            ;;
    esac
    
    if command -v java &> /dev/null; then
        print_success "Java instalado correctamente"
        java -version 2>&1 | head -n1 | tee -a "$LOG_FILE"
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar Java"
        FAILED_APPS+=("Java")
        ((FAILED_COUNT++))
        return 1
    fi
}

install_nodejs() {
    print_info "Instalando Node.js..."
    
    # Instalar desde NodeSource para obtener la última versión LTS
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - &>> "$LOG_FILE"
    
    if sudo apt install -y nodejs &>> "$LOG_FILE"; then
        print_success "Node.js instalado correctamente"
        node --version | tee -a "$LOG_FILE"
        npm --version | tee -a "$LOG_FILE"
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar Node.js"
        FAILED_APPS+=("Node.js")
        ((FAILED_COUNT++))
        return 1
    fi
}

install_go() {
    print_info "Instalando Go..."
    
    # Instalar Go desde los repositorios oficiales
    if sudo apt install -y golang-go &>> "$LOG_FILE"; then
        print_success "Go instalado correctamente"
        go version | tee -a "$LOG_FILE"
        
        # Configurar GOPATH si no existe
        if ! grep -q "GOPATH" ~/.bashrc; then
            echo "" >> ~/.bashrc
            echo "# Go configuration" >> ~/.bashrc
            echo "export GOPATH=\$HOME/go" >> ~/.bashrc
            echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.bashrc
            print_info "Variables de entorno de Go agregadas a ~/.bashrc"
        fi
        
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar Go"
        FAILED_APPS+=("Go")
        ((FAILED_COUNT++))
        return 1
    fi
}

install_rust() {
    print_info "Instalando Rust..."
    
    # Instalar dependencias necesarias
    sudo apt install -y build-essential curl &>> "$LOG_FILE"
    
    # Instalar Rust usando rustup (instalador oficial)
    if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y &>> "$LOG_FILE"; then
        print_success "Rust instalado correctamente"
        
        # Cargar el entorno de Rust
        source "$HOME/.cargo/env"
        
        rustc --version | tee -a "$LOG_FILE"
        cargo --version | tee -a "$LOG_FILE"
        
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar Rust"
        FAILED_APPS+=("Rust")
        ((FAILED_COUNT++))
        return 1
    fi
}

install_ruby() {
    print_info "Instalando Ruby..."
    
    # Instalar Ruby y sus herramientas de desarrollo
    if sudo apt install -y ruby-full ruby-dev &>> "$LOG_FILE"; then
        print_success "Ruby instalado correctamente"
        ruby --version | tee -a "$LOG_FILE"
        gem --version | tee -a "$LOG_FILE"
        
        # Configurar RubyGems para instalar sin sudo
        if ! grep -q "GEM_HOME" ~/.bashrc; then
            echo "" >> ~/.bashrc
            echo "# Ruby Gems configuration" >> ~/.bashrc
            echo "export GEM_HOME=\"\$HOME/.gems\"" >> ~/.bashrc
            echo "export PATH=\"\$HOME/.gems/bin:\$PATH\"" >> ~/.bashrc
            print_info "Variables de entorno de Ruby agregadas a ~/.bashrc"
        fi
        
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar Ruby"
        FAILED_APPS+=("Ruby")
        ((FAILED_COUNT++))
        return 1
    fi
}

install_dart() {
    print_info "Instalando Dart..."
    
    sudo apt install -y apt-transport-https wget &>> "$LOG_FILE"
    
    # Agregar repositorio oficial de Dart
    if ! [ -f /usr/share/keyrings/dart.gpg ]; then
        wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg &>> "$LOG_FILE"
    fi
    
    echo "deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main" \
        | sudo tee /etc/apt/sources.list.d/dart_stable.list &>> "$LOG_FILE"
    
    sudo apt update &>> "$LOG_FILE"
    
    if sudo apt install -y dart &>> "$LOG_FILE"; then
        print_success "Dart instalado correctamente"
        
        # Agregar Dart al PATH
        if ! grep -q "/usr/lib/dart/bin" ~/.bashrc; then
            echo "" >> ~/.bashrc
            echo "# Dart configuration" >> ~/.bashrc
            echo "export PATH=\"\$PATH:/usr/lib/dart/bin\"" >> ~/.bashrc
            print_info "Dart agregado al PATH en ~/.bashrc"
        fi
        
        /usr/lib/dart/bin/dart --version | tee -a "$LOG_FILE"
        
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar Dart"
        FAILED_APPS+=("Dart")
        ((FAILED_COUNT++))
        return 1
    fi
}

################################################################################
# Funciones de Instalación - Herramientas Adicionales
################################################################################

install_git() {
    print_info "Instalando Git..."
    
    if sudo apt install -y git git-gui gitk &>> "$LOG_FILE"; then
        print_success "Git instalado correctamente"
        git --version | tee -a "$LOG_FILE"
        
        # Configuración básica interactiva
        echo ""
        read -p "¿Deseas configurar Git ahora? [s/N]: " git_config
        if [[ $git_config =~ ^[Ss]$ ]]; then
            read -p "Ingresa tu nombre: " git_name
            read -p "Ingresa tu email: " git_email
            git config --global user.name "$git_name"
            git config --global user.email "$git_email"
            git config --global init.defaultBranch main
            print_success "Git configurado correctamente"
        fi
        
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar Git"
        FAILED_APPS+=("Git")
        ((FAILED_COUNT++))
        return 1
    fi
}

install_docker() {
    print_info "Instalando Docker..."
    
    # Instalar dependencias
    sudo apt install -y ca-certificates curl gnupg lsb-release &>> "$LOG_FILE"
    
    # Agregar clave GPG oficial de Docker
    sudo install -m 0755 -d /etc/apt/keyrings
    if ! [ -f /etc/apt/keyrings/docker.gpg ]; then
        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg &>> "$LOG_FILE"
    fi
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    
    # Configurar repositorio
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list &>> "$LOG_FILE"
    
    sudo apt update &>> "$LOG_FILE"
    
    # Instalar Docker Engine
    if sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &>> "$LOG_FILE"; then
        print_success "Docker instalado correctamente"
        
        # Agregar usuario al grupo docker
        sudo usermod -aG docker "$USER" &>> "$LOG_FILE"
        print_info "Usuario agregado al grupo docker (requiere cerrar sesión)"
        
        docker --version | tee -a "$LOG_FILE"
        
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar Docker"
        FAILED_APPS+=("Docker")
        ((FAILED_COUNT++))
        return 1
    fi
}

install_terminal_tools() {
    print_info "Instalando herramientas de terminal..."
    
    local tools="htop neofetch tree curl wget vim tmux net-tools build-essential"
    
    if sudo apt install -y $tools &>> "$LOG_FILE"; then
        print_success "Herramientas de terminal instaladas correctamente"
        echo -e "${CYAN}Herramientas instaladas:${NC}"
        echo "  • htop - Monitor de sistema interactivo"
        echo "  • neofetch - Información del sistema"
        echo "  • tree - Visualizador de estructura de directorios"
        echo "  • curl/wget - Herramientas de descarga"
        echo "  • vim - Editor de texto avanzado"
        echo "  • tmux - Multiplexor de terminal"
        echo "  • net-tools - Herramientas de red"
        echo "  • build-essential - Herramientas de compilación"
        
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar herramientas de terminal"
        FAILED_APPS+=("Herramientas de Terminal")
        ((FAILED_COUNT++))
        return 1
    fi
}

################################################################################
# Funciones de Instalación - Compatibilidad Windows (NO RECOMENDADO)
################################################################################

show_wine_warning() {
    echo ""
    echo -e "${RED}${BOLD}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}${BOLD}║                     ⚠️  ADVERTENCIA  ⚠️                        ║${NC}"
    echo -e "${RED}${BOLD}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}La compatibilidad con aplicaciones de Windows NO es recomendada:${NC}"
    echo ""
    echo -e "${RED}  ✗${NC} Puede causar inestabilidad en el sistema"
    echo -e "${RED}  ✗${NC} Rendimiento inferior a aplicaciones nativas"
    echo -e "${RED}  ✗${NC} No todas las aplicaciones funcionan correctamente"
    echo -e "${RED}  ✗${NC} Consume más recursos"
    echo ""
    echo -e "${GREEN}  ✓${NC} ${BOLD}Recomendación:${NC} Busca alternativas nativas de Linux"
    echo ""
    
    read -p "¿Estás seguro de que deseas continuar? [s/N]: " wine_confirm
    
    if [[ ! $wine_confirm =~ ^[Ss]$ ]]; then
        print_info "Instalación de Wine cancelada"
        return 1
    fi
    
    return 0
}

install_wine() {
    if ! show_wine_warning; then
        return 1
    fi
    
    print_info "Instalando Wine..."
    
    # Habilitar arquitectura de 32 bits
    sudo dpkg --add-architecture i386 &>> "$LOG_FILE"
    sudo apt update &>> "$LOG_FILE"
    
    # Instalar Wine
    if sudo apt install -y wine wine32 wine64 libwine libwine:i386 fonts-wine &>> "$LOG_FILE"; then
        print_success "Wine instalado correctamente"
        wine --version | tee -a "$LOG_FILE"
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar Wine"
        FAILED_APPS+=("Wine")
        ((FAILED_COUNT++))
        return 1
    fi
}

install_winetricks() {
    print_info "Instalando Winetricks..."
    
    if sudo apt install -y winetricks &>> "$LOG_FILE"; then
        print_success "Winetricks instalado correctamente"
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar Winetricks"
        FAILED_APPS+=("Winetricks")
        ((FAILED_COUNT++))
        return 1
    fi
}

install_playonlinux() {
    print_info "Instalando PlayOnLinux..."
    
    if sudo apt install -y playonlinux &>> "$LOG_FILE"; then
        print_success "PlayOnLinux instalado correctamente"
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar PlayOnLinux"
        FAILED_APPS+=("PlayOnLinux")
        ((FAILED_COUNT++))
        return 1
    fi
}

################################################################################
# Menús Interactivos
################################################################################

menu_browsers() {
    echo ""
    echo -e "${CYAN}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}${BOLD}     NAVEGADORES DISPONIBLES${NC}"
    echo -e "${CYAN}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "  1) Brave Browser"
    echo "  2) LibreWolf"
    echo "  3) Floorp"
    echo "  4) Supremium/Chromium"
    echo "  5) Todos los navegadores"
    echo "  0) Omitir navegadores"
    echo ""
    read -p "Opción [0-5]: " browser_choice
    
    case $browser_choice in
        1) install_brave ;;
        2) install_librewolf ;;
        3) install_floorp ;;
        4) install_supremium ;;
        5)
            install_brave
            install_librewolf
            install_floorp
            install_supremium
            ;;
        0) print_info "Omitiendo instalación de navegadores" ;;
        *) print_warning "Opción inválida" ;;
    esac
}

menu_applications() {
    echo ""
    echo -e "${GREEN}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}${BOLD}     APLICACIONES DISPONIBLES${NC}"
    echo -e "${GREEN}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "  1) Discord"
    echo "  2) Thunderbird"
    echo "  3) Session"
    echo "  4) LibreOffice"
    echo "  5) Todas las aplicaciones"
    echo "  0) Omitir aplicaciones"
    echo ""
    read -p "Opción [0-5]: " app_choice
    
    case $app_choice in
        1) install_discord ;;
        2) install_thunderbird ;;
        3) install_session ;;
        4) install_libreoffice ;;
        5)
            install_discord
            install_thunderbird
            install_session
            install_libreoffice
            ;;
        0) print_info "Omitiendo instalación de aplicaciones" ;;
        *) print_warning "Opción inválida" ;;
    esac
}

menu_development() {
    echo ""
    echo -e "${PURPLE}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}${BOLD}     HERRAMIENTAS DE DESARROLLO${NC}"
    echo -e "${PURPLE}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "  ${BOLD}Editores:${NC}"
    echo "    1) Visual Studio Code"
    echo ""
    echo "  ${BOLD}Lenguajes de Programación:${NC}"
    echo "    2) Python"
    echo "    3) C++"
    echo "    4) Java"
    echo "    5) Node.js"
    echo "    6) Go"
    echo "    7) Rust"
    echo "    8) Ruby"
    echo "    9) Dart"
    echo ""
    echo "  ${BOLD}Opciones Múltiples:${NC}"
    echo "    10) Todos los lenguajes"
    echo "    11) Todo (Editor + Lenguajes)"
    echo "    0) Omitir desarrollo"
    echo ""
    read -p "Opción [0-11]: " dev_choice
    
    case $dev_choice in
        1) install_vscode ;;
        2) install_python ;;
        3) install_cpp ;;
        4) install_java ;;
        5) install_nodejs ;;
        6) install_go ;;
        7) install_rust ;;
        8) install_ruby ;;
        9) install_dart ;;
        10)
            install_python
            install_cpp
            install_java
            install_nodejs
            install_go
            install_rust
            install_ruby
            install_dart
            ;;
        11)
            install_vscode
            install_python
            install_cpp
            install_java
            install_nodejs
            install_go
            install_rust
            install_ruby
            install_dart
            ;;
        0) print_info "Omitiendo instalación de herramientas de desarrollo" ;;
        *) print_warning "Opción inválida" ;;
    esac
}

menu_tools() {
    echo ""
    echo -e "${YELLOW}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}${BOLD}     HERRAMIENTAS ADICIONALES${NC}"
    echo -e "${YELLOW}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "  1) Git (Control de versiones)"
    echo "  2) Docker (Contenedores)"
    echo "  3) Herramientas de Terminal (htop, neofetch, tree, vim, etc.)"
    echo "  4) Todas las herramientas"
    echo "  0) Omitir herramientas adicionales"
    echo ""
    read -p "Opción [0-4]: " tools_choice
    
    case $tools_choice in
        1) install_git ;;
        2) install_docker ;;
        3) install_terminal_tools ;;
        4)
            install_git
            install_docker
            install_terminal_tools
            ;;
        0) print_info "Omitiendo instalación de herramientas adicionales" ;;
        *) print_warning "Opción inválida" ;;
    esac
}

menu_wine() {
    echo ""
    echo -e "${RED}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${RED}${BOLD}     COMPATIBILIDAD CON WINDOWS (⚠️ NO RECOMENDADO)${NC}"
    echo -e "${RED}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "  1) Wine (capa de compatibilidad)"
    echo "  2) Winetricks (gestor de componentes)"
    echo "  3) PlayOnLinux (interfaz gráfica)"
    echo "  4) Instalar todo (Wine + Winetricks + PlayOnLinux)"
    echo "  0) Omitir compatibilidad con Windows"
    echo ""
    read -p "Opción [0-4]: " wine_choice
    
    case $wine_choice in
        1) install_wine ;;
        2) 
            install_wine
            if [ $? -eq 0 ]; then
                install_winetricks
            fi
            ;;
        3) 
            install_wine
            if [ $? -eq 0 ]; then
                install_playonlinux
            fi
            ;;
        4)
            install_wine
            if [ $? -eq 0 ]; then
                install_winetricks
                install_playonlinux
            fi
            ;;
        0) print_info "Omitiendo instalación de compatibilidad con Windows" ;;
        *) print_warning "Opción inválida" ;;
    esac
}

################################################################################
# Resumen Final
################################################################################

show_summary() {
    echo ""
    echo -e "${BOLD}${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${GREEN}     RESUMEN DE INSTALACIÓN${NC}"
    echo -e "${BOLD}${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${GREEN}✓ Aplicaciones instaladas correctamente: ${BOLD}$INSTALL_COUNT${NC}"
    
    if [ $FAILED_COUNT -gt 0 ]; then
        echo -e "${RED}✗ Aplicaciones con errores: ${BOLD}$FAILED_COUNT${NC}"
        echo ""
        echo -e "${YELLOW}Aplicaciones que fallaron:${NC}"
        for app in "${FAILED_APPS[@]}"; do
            echo -e "  ${RED}●${NC} $app"
        done
    fi
    
    echo ""
    echo -e "${CYAN}Log guardado en:${NC} $LOG_FILE"
    echo ""
    
    if [ $FAILED_COUNT -eq 0 ]; then
        echo -e "${GREEN}${BOLD}¡Instalación completada exitosamente! 🎉${NC}"
    else
        echo -e "${YELLOW}${BOLD}Instalación completada con algunos errores.${NC}"
        echo -e "${YELLOW}Revisa el log para más detalles.${NC}"
    fi
    
    echo ""
    read -p "¿Deseas reiniciar el sistema ahora? [s/N]: " reboot_choice
    if [[ $reboot_choice =~ ^[Ss]$ ]]; then
        print_info "Reiniciando sistema en 5 segundos..."
        sleep 5
        sudo reboot
    fi
}

################################################################################
# Función Principal
################################################################################

main() {
    show_banner
    create_log_dir
    
    print_info "Iniciando EasyLinux Installer..."
    log "===== INICIO DE INSTALACIÓN ====="
    
    # Verificaciones iniciales
    check_sudo
    detect_distro
    
    if ! check_internet; then
        print_error "Se requiere conexión a Internet para continuar"
        exit 1
    fi
    
    echo ""
    read -p "¿Deseas actualizar el sistema antes de instalar aplicaciones? [S/n]: " update_choice
    if [[ ! $update_choice =~ ^[Nn]$ ]]; then
        update_system
    fi
    
    # Menú principal
    while true; do
        echo ""
        echo -e "${BOLD}${BLUE}═══════════════════════════════════════════════════════════════${NC}"
        echo -e "${BOLD}${BLUE}     MENÚ PRINCIPAL${NC}"
        echo -e "${BOLD}${BLUE}═══════════════════════════════════════════════════════════════${NC}"
        echo ""
        echo "  1) Instalar Navegadores"
        echo "  2) Instalar Aplicaciones"
        echo "  3) Instalar Herramientas de Desarrollo"
        echo "  4) Instalar Herramientas Adicionales (Git, Docker, etc.)"
        echo "  5) Compatibilidad con Windows (⚠️ NO RECOMENDADO)"
        echo "  6) Instalar TODO (sin Wine)"
        echo "  0) Salir"
        echo ""
        read -p "Selecciona una opción [0-6]: " main_choice
        
        case $main_choice in
            1) menu_browsers ;;
            2) menu_applications ;;
            3) menu_development ;;
            4) menu_tools ;;
            5) menu_wine ;;
            6)
                print_info "Instalando todas las aplicaciones (sin compatibilidad Windows)..."
                menu_browsers
                menu_applications
                menu_development
                menu_tools
                break
                ;;
            0)
                if [ $INSTALL_COUNT -gt 0 ]; then
                    show_summary
                fi
                print_info "Saliendo..."
                exit 0
                ;;
            *)
                print_warning "Opción inválida"
                ;;
        esac
        
        echo ""
        read -p "¿Deseas instalar más aplicaciones? [S/n]: " continue_choice
        if [[ $continue_choice =~ ^[Nn]$ ]]; then
            break
        fi
    done
    
    # Mostrar resumen
    show_summary
    
    log "===== FIN DE INSTALACIÓN ====="
}

################################################################################
# Ejecución
################################################################################

main "$@"
