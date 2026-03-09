# Registro de Cambios - EasyLinux

Todos los cambios notables en este proyecto serán documentados en este archivo.

## [2.0] - 2026-03-09  

### ✨ Nuevas Funcionalidades

#### Nuevos Lenguajes de Programación
- **Go** - Lenguaje moderno y eficiente de Google
  - Instalación desde repositorios oficiales
  - Configuración automática de GOPATH
  - Variables de entorno agregadas a .bashrc

- **Rust** - Lenguaje seguro y rápido
  - Instalación vía rustup (instalador oficial)
  - Incluye cargo y rustc
  - Configuración automática del entorno

- **Ruby** - Lenguaje dinámico y elegante
  - Instalación completa con ruby-full
  - Incluye RubyGems
  - Configuración de GEM_HOME para instalación sin sudo

- **Dart** - Lenguaje optimizado para apps móviles y web
  - Instalación desde repositorio oficial de Google
  - Configuración automática del PATH
  - Ideal para desarrollo con Flutter

#### Herramientas Adicionales

- **Git** - Sistema de control de versiones
  - Instalación completa con git-gui y gitk
  - Configuración interactiva (nombre y email)
  - Branch por defecto configurado a 'main'

- **Docker** - Plataforma de contenedores
  - Instalación desde repositorio oficial de Docker
  - Incluye Docker Compose y Docker Buildx
  - Usuario agregado al grupo docker automáticamente

- **Herramientas de Terminal** (instalación conjunta)
  - htop - Monitor de sistema interactivo
  - neofetch - Información del sistema con estilo
  - tree - Visualizador de estructura de directorios
  - vim - Editor de texto avanzado
  - tmux - Multiplexor de terminal
  - curl/wget - Herramientas de descarga
  - net-tools - Utilidades de red
  - build-essential - Herramientas de compilación

### 🎨 Mejoras en la Interfaz

- **Nuevo menú de Herramientas Adicionales**
  - Opción dedicada para Git, Docker y herramientas de terminal
  - Instalación individual o en conjunto

- **Menú de Desarrollo Mejorado**
  - Reorganizado con categorías (Editores, Lenguajes)
  - Opciones expandidas de 6 a 11
  - Nueva opción "Todos los lenguajes"
  - Nueva opción "Todo (Editor + Lenguajes)"

- **Menú Principal Actualizado**
  - 6 opciones principales (antes 5)
  - Nueva categoría de Herramientas Adicionales
  - Opción "Instalar TODO" ahora incluye herramientas adicionales

### 📝 Documentación

- README actualizado con todas las nuevas funcionalidades
- Tablas extendidas con información de nuevos lenguajes
- Nueva sección de Herramientas Adicionales
- Versión actualizada a 2.0

### 🔧 Mejoras Técnicas

- Variables de entorno configuradas automáticamente para:
  - Go (GOPATH)
  - Ruby (GEM_HOME)
  - Rust (cargo environment)
  - Dart (PATH)

- Mensajes informativos mejorados
- Verificación de instalaciones existentes
- Mejor manejo de errores

### 📊 Estadísticas

- **4 nuevos lenguajes de programación** añadidos
- **3 categorías de herramientas adicionales** nuevas
- **10+ herramientas de terminal** incluidas
- Total de **20+ aplicaciones/herramientas** disponibles

---

## [1.0] - 2026-03-01

### ✨ Lanzamiento Inicial

#### Funcionalidades Base

- Sistema de menús interactivos
- Actualización automática del sistema
- Logging completo de instalaciones
- Barra de progreso visual
- Resumen de instalación

#### Navegadores Incluidos
- Brave Browser
- LibreWolf
- Floorp
- Supremium/Chromium

#### Aplicaciones de Comunicación
- Discord
- Thunderbird
- Session

#### Suite Ofimática
- LibreOffice (con soporte en español)

#### Herramientas de Desarrollo
- Visual Studio Code
- Python 3.x
- C++ (g++/gcc)
- Java (múltiples versiones LTS)
- Node.js

#### Compatibilidad Windows (NO RECOMENDADO)
- Wine
- Winetricks
- PlayOnLinux
- Sistema de advertencias

### 🎨 Interfaz
- Banner ASCII colorido
- Menús con códigos de color
- Mensajes informativos con íconos
- Sistema de logging a archivo

### 🔐 Seguridad
- Verificación de permisos sudo
- No permite ejecución como root
- Verificación de conexión a Internet
- Detección automática de distribución

---

## Leyenda

- ✨ Nuevas funcionalidades
- 🎨 Mejoras en la interfaz
- 🔧 Mejoras técnicas
- 📝 Documentación
- 🐛 Corrección de errores
- 🔐 Seguridad
- ⚠️ Advertencias importantes
- 📊 Estadísticas
