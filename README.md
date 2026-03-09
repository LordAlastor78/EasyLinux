# 🐧 EasyLinux - Instalador Automático

[![Estado](https://img.shields.io/badge/estado-activo-success.svg)](https://github.com/tu-usuario/EasyLinux)
[![Versión](https://img.shields.io/badge/versión-1.0-blue.svg)](https://github.com/tu-usuario/EasyLinux)
[![Licencia](https://img.shields.io/badge/licencia-MIT-green.svg)](LICENSE)

Script de configuración automática para distribuciones Linux basadas en Debian. Perfecto para configurar rápidamente un sistema nuevo con todas tus aplicaciones y herramientas de desarrollo favoritas.

## 📋 Tabla de Contenidos

- [Características](#-características)
- [Requisitos](#-requisitos)
- [Instalación y Uso](#-instalación-y-uso)
- [Software Disponible](#-software-disponible)
- [Capturas de Pantalla](#-capturas-de-pantalla)
- [Solución de Problemas](#-solución-de-problemas)
- [Contribuir](#-contribuir)
- [Licencia](#-licencia)

## ✨ Características

- **🚀 Instalación Rápida**: Automatiza la instalación de todas tus aplicaciones favoritas
- **🎯 Menú Interactivo**: Interfaz amigable con menús de selección
- **📊 Barra de Progreso**: Visualiza el progreso de instalación en tiempo real
- **🔍 Verificaciones**: Comprueba permisos, conexión a Internet y sistema operativo
- **📝 Logging Completo**: Todos los procesos se registran en archivos log
- **🎨 Interfaz Colorida**: Mensajes con colores para mejor legibilidad
- **🔐 Seguro**: No requiere ejecutarse como root, solicita sudo cuando es necesario
- **📦 Múltiples Fuentes**: Instala desde APT, Flatpak, descarga directa, etc.

## 🔧 Requisitos

- **Sistema Operativo**: 
  - Parrot OS (recomendado)
  - Debian 11+ / Ubuntu 20.04+
  - Linux Mint 20+
  - Cualquier derivada de Debian
  
- **Hardware**:
  - Al menos 5GB de espacio libre
  - Conexión a Internet activa
  - Procesador de 64 bits (amd64)

- **Permisos**:
  - Usuario con privilegios sudo
  - No ejecutar como root

## 🚀 Instalación y Uso

### Método 1: Clonando el repositorio

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/EasyLinux.git

# Entrar al directorio
cd EasyLinux

# Dar permisos de ejecución
chmod +x install.sh

# Ejecutar el script
./install.sh
```

### Método 2: Descarga directa

```bash
# Descargar el script
wget https://raw.githubusercontent.com/tu-usuario/EasyLinux/main/install.sh

# Dar permisos de ejecución
chmod +x install.sh

# Ejecutar
./install.sh
```

### Método 3: Ejecución directa (una línea)

```bash
bash <(wget -qO- https://raw.githubusercontent.com/tu-usuario/EasyLinux/main/install.sh)
```

## 📦 Software Disponible

### 🌐 Navegadores Web

| Navegador | Descripción | Método de Instalación |
|-----------|-------------|----------------------|
| **Brave** | Navegador enfocado en privacidad con bloqueador de anuncios | APT (repo oficial) |
| **LibreWolf** | Firefox sin telemetría ni rastreadores | APT (repo oficial) |
| **Floorp** | Firefox con características avanzadas | Flatpak |
| **Supremium/Chromium** | Chrome open source | APT/Flatpak |

### 💬 Aplicaciones de Comunicación

| Aplicación | Descripción | Método de Instalación |
|------------|-------------|----------------------|
| **Discord** | Plataforma de comunicación para comunidades | Flatpak/DEB |
| **Thunderbird** | Cliente de correo electrónico de código abierto | APT |
| **Session** | Mensajería privada sin números de teléfono | DEB directo |

### 📄 Productividad

| Aplicación | Descripción | Método de Instalación |
|------------|-------------|----------------------|
| **LibreOffice** | Suite ofimática completa (Writer, Calc, Impress, etc.) | APT |

### 👨‍💻 Herramientas de Desarrollo

#### Editor de Código
- **Visual Studio Code** - IDE completo con extensiones

#### Lenguajes y Compiladores

| Herramienta | Descripción | Versiones |
|-------------|-------------|-----------|
| **Python** | Lenguaje interpretado + pip + venv | Latest 3.x |
| **C++** | Compilador g++/gcc + build-essential + CMake | Latest |
| **Java** | OpenJDK | 17 LTS / 21 LTS / 25 |
| **Node.js** | Runtime JavaScript + npm | LTS |

### ⚠️ Compatibilidad con Windows (NO RECOMENDADO)

> **⚠️ ADVERTENCIA:** Esta opción no es recomendada. Preferible usar aplicaciones nativas de Linux.
> 
> 📚 **Documentación adicional:**
> - [WINE_ALTERNATIVES.md](WINE_ALTERNATIVES.md) - Lista completa de alternativas nativas
> - [WINE_GUIDE.md](WINE_GUIDE.md) - Guía técnica detallada de Wine

| Herramienta | Descripción | Método de Instalación |
|-------------|-------------|----------------------|
| **Wine** | Capa de compatibilidad para ejecutar apps Windows | APT |
| **Winetricks** | Gestor de componentes Windows | APT |
| **PlayOnLinux** | Interfaz gráfica para Wine | APT |

**Limitaciones:**
- ❌ Puede causar inestabilidad en el sistema
- ❌ Rendimiento inferior a aplicaciones nativas
- ❌ No garantiza que todas las aplicaciones funcionen
- ❌ Mayor consumo de recursos

**Recomendación:** Consulta [WINE_ALTERNATIVES.md](WINE_ALTERNATIVES.md) para encontrar alternativas nativas antes de instalar Wine.

## 🎬 Capturas de Pantalla

### Banner de Inicio
```
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║                    🐧 EASY LINUX INSTALLER 🐧                  ║
║                                                                ║
║         Configuración automática para tu nuevo sistema        ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
```

### Menú Principal
```
═══════════════════════════════════════════════════════════════
     MENÚ PRINCIPAL
═══════════════════════════════════════════════════════════════

  1) Instalar Navegadores
  2) Instalar Aplicaciones
  3) Instalar Herramientas de Desarrollo
  4) Compatibilidad con Windows (⚠️ NO RECOMENDADO)
  5) Instalar TODO (sin Wine)
  0) Salir

Selecciona una opción [0-5]:
```

## 🛠️ Solución de Problemas

### El script no tiene permisos de ejecución

```bash
chmod +x install.sh
```

### Error de permisos sudo

Asegúrate de que tu usuario está en el grupo sudo:

```bash
sudo usermod -aG sudo $USER
# Cerrar sesión y volver a entrar
```

### Error de conexión a Internet

Verifica tu conexión:

```bash
ping -c 4 8.8.8.8
```

### Flatpak no instalado

El script instalará Flatpak automáticamente si es necesario, pero puedes hacerlo manualmente:

```bash
sudo apt install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

### Ver logs de instalación

Los logs se guardan en `~/.easylinux/logs/`:

```bash
# Ver el último log
ls -lt ~/.easylinux/logs/ | head -n 2

# Leer un log específico
cat ~/.easylinux/logs/install_YYYYMMDD_HHMMSS.log

# Ver errores en el último log
grep ERROR ~/.easylinux/logs/install_*.log | tail -n 20
```

### Una aplicación falló al instalarse

1. Revisa el log correspondiente
2. Intenta instalar manualmente:
   ```bash
   sudo apt update
   sudo apt install nombre-del-paquete
   ```
3. Verifica que los repositorios estén configurados correctamente

### Sistema no actualiza

```bash
# Limpiar cache de apt
sudo apt clean
sudo apt autoclean

# Actualizar lista de paquetes
sudo apt update

# Ejecutar una actualización completa
sudo apt full-upgrade
```

### Problemas con Wine (Compatibilidad Windows)

#### Wine no se instala correctamente

```bash
# Verificar soporte de arquitectura 32 bits
dpkg --print-foreign-architectures

# Si no aparece i386, agregarlo
sudo dpkg --add-architecture i386
sudo apt update

# Reinstalar Wine
sudo apt install --reinstall wine wine32 wine64
```

#### Una aplicación de Windows no funciona con Wine

1. **Verifica la compatibilidad**: No todas las aplicaciones Windows funcionan en Wine
   - Consulta la base de datos: https://appdb.winehq.org/

2. **Instala dependencias con Winetricks**:
   ```bash
   winetricks
   # Selecciona los componentes necesarios (vcrun, dotnet, etc.)
   ```

3. **Usa PlayOnLinux para mejor compatibilidad**:
   - PlayOnLinux gestiona múltiples versiones de Wine
   - Mejor soporte para juegos y aplicaciones complejas

4. **Busca alternativas nativas**:
   - Siempre es mejor usar aplicaciones nativas de Linux
   - Ejemplo: LibreOffice en lugar de Microsoft Office

#### Desinstalar Wine completamente

```bash
# Eliminar Wine y sus dependencias
sudo apt remove --purge wine wine32 wine64 winetricks playonlinux
sudo apt autoremove

# Eliminar configuración de usuario
rm -rf ~/.wine
rm -rf ~/.PlayOnLinux
```

## 📁 Estructura de Archivos

```
EasyLinux/
├── install.sh              # Script principal
├── Objetivos.md            # Especificaciones del proyecto
├── README.md               # Este archivo
├── WINE_ALTERNATIVES.md    # Alternativas nativas a apps Windows
├── WINE_GUIDE.md          # Guía técnica de Wine
└── logs/                  # Carpeta de logs (creada automáticamente)
    └── install_*.log      # Logs de instalación
```

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! Si quieres agregar más aplicaciones o mejorar el script:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/NuevaAplicacion`)
3. Commit tus cambios (`git commit -m 'Añadir nueva aplicación'`)
4. Push a la rama (`git push origin feature/NuevaAplicacion`)
5. Abre un Pull Request

### Añadir una nueva aplicación

Para añadir una nueva aplicación al script:

1. Crea la función de instalación:
```bash
install_miapp() {
    print_info "Instalando MiApp..."
    
    if sudo apt install -y miapp &>> "$LOG_FILE"; then
        print_success "MiApp instalado correctamente"
        ((INSTALL_COUNT++))
        return 0
    else
        print_error "Error al instalar MiApp"
        FAILED_APPS+=("MiApp")
        ((FAILED_COUNT++))
        return 1
    fi
}
```

2. Añade la opción al menú correspondiente
3. Documenta en el README.md

## 📝 Notas Importantes

- **No ejecutes el script como root**: El script solicitará permisos sudo cuando sea necesario
- **Revisa los logs**: Todos los comandos se registran para debugging
- **Conexión a Internet**: Requerida durante toda la instalación
- **Tiempo de instalación**: Varía según las aplicaciones seleccionadas (10-30 minutos aprox.)
- **Reinicio recomendado**: Después de instalar todo, se recomienda reiniciar el sistema
- **⚠️ Wine NO recomendado**: Evita instalar Wine a menos que sea absolutamente necesario. Busca siempre alternativas nativas de Linux primero.

## 🔜 Próximas Características

- [ ] Soporte para más distribuciones (Arch, Fedora)
- [ ] Interfaz gráfica con Zenity/YAD
- [ ] Configuración mediante archivo JSON
- [ ] Modo desatendido (sin interacción)
- [ ] Backup y restauración de configuraciones
- [ ] Perfiles personalizados (Desarrollador, Gamer, Ofimática)
- [ ] Instalación de temas y personalización visual
- [ ] Configuración automática de dotfiles

## 📜 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 👤 Autor

**Alastor**

- GitHub: [@tu-usuario](https://github.com/tu-usuario)

## 🙏 Agradecimientos

- A la comunidad de código abierto
- A los desarrolladores de todas las aplicaciones incluidas
- A los usuarios que contribuyen con feedback y mejoras

---

<div align="center">

**⭐ Si este proyecto te ha sido útil, considera darle una estrella ⭐**

Hecho con ❤️ para la comunidad Linux

</div>
