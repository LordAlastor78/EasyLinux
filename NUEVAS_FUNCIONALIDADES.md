# 🎉 Nuevas Funcionalidades - EasyLinux v2.0

## Resumen de Mejoras

Se han agregado **múltiples funcionalidades nuevas** al instalador EasyLinux, actualizándolo de la versión 1.0 a la versión 2.0.

---

## 🆕 Nuevos Lenguajes de Programación

### 1. **Go (Golang)** 
- ✅ Instalación desde repositorios oficiales
- ✅ Configuración automática de `GOPATH`
- ✅ Variables de entorno agregadas a `~/.bashrc`
- 📦 Comando: Opción 6 en el Menú de Desarrollo

**Qué incluye:**
- Compilador Go
- Herramientas de desarrollo Go
- GOPATH configurado en `$HOME/go`

---

### 2. **Rust**
- ✅ Instalación vía `rustup` (instalador oficial)
- ✅ Incluye `cargo` (gestor de paquetes)
- ✅ Incluye `rustc` (compilador)
- ✅ Configuración automática del entorno
- 📦 Comando: Opción 7 en el Menú de Desarrollo

**Qué incluye:**
- Rust compiler (rustc)
- Cargo (build system y package manager)
- Herramientas de desarrollo Rust
- Actualizaciones fáciles con rustup

---

### 3. **Ruby**
- ✅ Instalación completa con `ruby-full`
- ✅ Incluye RubyGems
- ✅ Configuración de `GEM_HOME` para instalación sin sudo
- ✅ Variables de entorno en `~/.bashrc`
- 📦 Comando: Opción 8 en el Menú de Desarrollo

**Qué incluye:**
- Intérprete Ruby
- RubyGems (gestor de gemas)
- Ruby development headers
- Configuración para instalar gemas sin privilegios de root

---

### 4. **Dart**
- ✅ Instalación desde repositorio oficial de Google
- ✅ Configuración automática del PATH
- ✅ Ideal para desarrollo con Flutter
- 📦 Comando: Opción 9 en el Menú de Desarrollo

**Qué incluye:**
- Dart SDK
- Dart compiler
- Dart analyzer
- Perfecto para desarrollo Flutter/Web

---

## 🛠️ Nuevas Herramientas Adicionales

### 1. **Git - Control de Versiones**
- ✅ Git + git-gui + gitk
- ✅ Configuración interactiva (nombre y email)
- ✅ Branch por defecto configurado a `main`
- 📦 Comando: Opción 1 en el Menú de Herramientas Adicionales

**Características:**
- Configuración automática de usuario
- Interfaz gráfica incluida
- Listo para usar con GitHub/GitLab

---

### 2. **Docker - Plataforma de Contenedores**
- ✅ Docker Engine
- ✅ Docker Compose
- ✅ Docker Buildx
- ✅ Usuario agregado al grupo docker automáticamente
- 📦 Comando: Opción 2 en el Menú de Herramientas Adicionales

**Qué incluye:**
- Docker CE (Community Edition)
- Docker Compose Plugin
- Docker Buildx Plugin
- containerd.io

**Nota:** Después de instalar, necesitas cerrar sesión y volver a entrar para usar docker sin sudo.

---

### 3. **Herramientas de Terminal**
Paquete completo de herramientas esenciales para terminal
- 📦 Comando: Opción 3 en el Menú de Herramientas Adicionales

**Incluye:**
- **htop** - Monitor de sistema interactivo y mejorado
- **neofetch** - Muestra información del sistema con estilo
- **tree** - Visualiza estructura de directorios en árbol
- **vim** - Editor de texto avanzado
- **tmux** - Multiplexor de terminal (múltiples sesiones)
- **curl/wget** - Herramientas de descarga por HTTP/FTP
- **net-tools** - Utilidades de red (ifconfig, netstat, etc.)
- **build-essential** - Compiladores y herramientas de construcción

---

## 📋 Menús Actualizados

### Menú Principal (Actualizado)
```
1) Instalar Navegadores
2) Instalar Aplicaciones
3) Instalar Herramientas de Desarrollo
4) Instalar Herramientas Adicionales (Git, Docker, etc.) ← NUEVO
5) Compatibilidad con Windows (⚠️ NO RECOMENDADO)
6) Instalar TODO (sin Wine)
0) Salir
```

### Menú de Desarrollo (Reorganizado y Expandido)
```
Editores:
  1) Visual Studio Code

Lenguajes de Programación:
  2) Python
  3) C++
  4) Java
  5) Node.js
  6) Go          ← NUEVO
  7) Rust        ← NUEVO
  8) Ruby        ← NUEVO
  9) Dart        ← NUEVO

Opciones Múltiples:
  10) Todos los lenguajes
  11) Todo (Editor + Lenguajes)
  0) Omitir desarrollo
```

### Menú de Herramientas Adicionales (NUEVO)
```
1) Git (Control de versiones)
2) Docker (Contenedores)
3) Herramientas de Terminal (htop, neofetch, tree, vim, etc.)
4) Todas las herramientas
0) Omitir herramientas adicionales
```

---

## 📊 Estadísticas

### Antes (v1.0)
- 4 Navegadores
- 4 Aplicaciones
- 5 Lenguajes de programación
- 3 Herramientas de compatibilidad Windows

**Total: ~16 aplicaciones**

### Ahora (v2.0)
- 4 Navegadores
- 4 Aplicaciones
- **9 Lenguajes de programación** (+4)
- 3 Categorías de herramientas adicionales (+3)
- 10+ herramientas de terminal
- 3 Herramientas de compatibilidad Windows

**Total: ~30+ aplicaciones/herramientas** 🎉

---

## 🚀 Cómo Usar las Nuevas Funcionalidades

### Instalación Rápida de Todo lo Nuevo
```bash
./install.sh
# Selecciona: Opción 6 (Instalar TODO)
```

### Instalar Solo Lenguajes Nuevos
```bash
./install.sh
# Selecciona: Opción 3 (Herramientas de Desarrollo)
# Luego: Opción 10 (Todos los lenguajes)
```

### Instalar Solo Herramientas Adicionales
```bash
./install.sh
# Selecciona: Opción 4 (Herramientas Adicionales)
# Luego: Opción 4 (Todas las herramientas)
```

---

## 🎯 Recomendaciones

### Para Desarrolladores Full-Stack
```bash
Instala:
- VSCode (opción 1 en Desarrollo)
- Todos los lenguajes (opción 10 en Desarrollo)
- Git y Docker (opciones 1-2 en Herramientas)
```

### Para Desarrolladores de Sistemas
```bash
Instala:
- C++, Rust, Go (opciones 3, 7, 6 en Desarrollo)
- Herramientas de Terminal (opción 3 en Herramientas)
- Git (opción 1 en Herramientas)
```

### Para Desarrolladores Web
```bash
Instala:
- Node.js, Ruby, Dart (opciones 5, 8, 9 en Desarrollo)
- VSCode (opción 1 en Desarrollo)
- Git y Docker (opciones 1-2 en Herramientas)
```

---

## 📝 Notas Importantes

### Variables de Entorno
Después de instalar algunos lenguajes, necesitarás recargar tu shell:
```bash
source ~/.bashrc
```

O simplemente cierra y abre una nueva terminal.

### Docker
Después de instalar Docker, necesitas cerrar sesión y volver a entrar para poder usar docker sin sudo.

### Verificación de Instalaciones
Para verificar que todo se instaló correctamente:
```bash
# Go
go version

# Rust
rustc --version
cargo --version

# Ruby
ruby --version
gem --version

# Dart
dart --version

# Git
git --version

# Docker
docker --version
docker compose version
```

---

## 🐛 Solución de Problemas

### Si un lenguaje no se encuentra después de instalar
```bash
# Recarga el shell
source ~/.bashrc

# O cierra y abre una nueva terminal
```

### Si Docker no funciona
```bash
# Verifica que estés en el grupo docker
groups

# Si no aparece 'docker', cierra sesión y vuelve a entrar
```

### Para ver los logs de instalación
```bash
ls ~/.easylinux/logs/
cat ~/.easylinux/logs/install_*.log
```

---

## 📚 Archivos Actualizados

- ✅ `install.sh` - Script principal actualizado a v2.0
- ✅ `README.md` - Documentación actualizada
- ✅ `Objetivos.md` - Objetivos cumplidos marcados
- ✅ `CHANGELOG.md` - Registro detallado de cambios (NUEVO)
- ✅ `NUEVAS_FUNCIONALIDADES.md` - Este archivo (NUEVO)

---

## 🎉 ¡Disfruta de las Nuevas Funcionalidades!

Si tienes alguna sugerencia o encuentras algún problema, no dudes en reportarlo.

**Versión:** 2.0  
**Fecha:** Marzo 2026  
**Desarrollador:** Alastor
