#!/bin/bash

################################################################################
# EasyLinux - Script de Configuración Automática
# Versión: 1.0
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
    echo "  1) Visual Studio Code"
    echo "  2) Python"
    echo "  3) C++"
    echo "  4) Java"
    echo "  5) Node.js"
    echo "  6) Todas las herramientas"
    echo "  0) Omitir desarrollo"
    echo ""
    read -p "Opción [0-6]: " dev_choice
    
    case $dev_choice in
        1) install_vscode ;;
        2) install_python ;;
        3) install_cpp ;;
        4) install_java ;;
        5) install_nodejs ;;
        6)
            install_vscode
            install_python
            install_cpp
            install_java
            install_nodejs
            ;;
        0) print_info "Omitiendo instalación de herramientas de desarrollo" ;;
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
        echo "  4) Compatibilidad con Windows (⚠️ NO RECOMENDADO)"
        echo "  5) Instalar TODO (sin Wine)"
        echo "  0) Salir"
        echo ""
        read -p "Selecciona una opción [0-5]: " main_choice
        
        case $main_choice in
            1) menu_browsers ;;
            2) menu_applications ;;
            3) menu_development ;;
            4) menu_wine ;;
            5)
                print_info "Instalando todas las aplicaciones (sin compatibilidad Windows)..."
                menu_browsers
                menu_applications
                menu_development
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
