# EasyLinux - Objetivos del Proyecto

## Descripción General
Script de configuración automática para distribuciones Linux (principalmente Parrot OS) que facilita la instalación de software esencial en dispositivos nuevos.

## Funcionalidades Principales

### 1. Actualización del Sistema
- Actualización completa del sistema operativo
- Optimizado para Parrot OS
- Soporte para derivadas de Debian/Ubuntu

### 2. Navegadores Web
El usuario podrá elegir entre los siguientes navegadores:
- **Floorp** - Navegador basado en Firefox con características avanzadas
- **Supremium** - Navegador basado en Chromium
- **Brave** - Navegador enfocado en privacidad
- **LibreWolf** - Firefox sin telemetría

### 3. Aplicaciones de Comunicación y Productividad
- **Discord** - Plataforma de comunicación
- **Thunderbird** - Cliente de correo electrónico
- **Session** - Mensajería privada y segura

### 4. Suite Ofimática
- **LibreOffice** - Suite completa de productividad

### 5. Entorno de Desarrollo
#### Editor de Código
- **Visual Studio Code** - IDE principal

#### Lenguajes de Programación y Compiladores
- **Python** - Última versión estable
- **C++** - Compilador g++/gcc
- **Java** - Opciones:
  - Java 25 LTS
  - Java 21 LTS
  - Java 17 LTS
- **Node.js** - Entorno de ejecución JavaScript
- **Go** - Lenguaje de programación moderno y eficiente
- **Rust** - Lenguaje de programación seguro y rápido
- **Ruby** - Lenguaje de programación dinámico y fácil de aprender
- **Dart** - Lenguaje de programación optimizado para aplicaciones móviles y web

### 6. Compatibilidad con Windows (⚠️ No Recomendado)
Herramientas para ejecutar aplicaciones de Windows en Linux:
- **Wine** - Capa de compatibilidad para ejecutar aplicaciones Windows
- **Winetricks** - Gestor de componentes y librerías Windows
- **PlayOnLinux** - Interfaz gráfica para gestionar Wine

**⚠️ ADVERTENCIA:** Esta opción no es recomendada porque:
- Puede causar inestabilidad en el sistema
- Rendimiento inferior comparado con aplicaciones nativas
- No todas las aplicaciones Windows funcionan correctamente
- Preferible usar alternativas nativas de Linux

## Características Técnicas

### Interfaz de Usuario
- Menú interactivo con opciones numeradas
- Selección múltiple de aplicaciones
- Confirmación antes de instalar
- Barra de progreso y mensajes informativos

### Gestión de Errores
- Verificación de permisos sudo
- Validación de conexión a Internet
- Manejo de errores en instalaciones fallidas
- Logs de instalación

### Compatibilidad
- **Principal:** Parrot OS
- **Secundaria:** Debian, Ubuntu y derivadas
- Detección automática de la distribución

## Estructura del Proyecto

```
EasyLinux/
├── Objetivos.md          # Este archivo
├── README.md             # Guía de uso
├── install.sh            # Script principal
└── logs/                 # Carpeta para logs (creada automáticamente)
```

## Requisitos del Sistema
- Distribución Linux basada en Debian
- Permisos de administrador (sudo)
- Conexión a Internet activa
- Al menos 8GB de espacio libre en disco (12GB si se instala Wine)

## Flujo de Trabajo del Script

1. **Inicio**
   - Verificación de permisos
   - Verificación de conexión a Internet
   - Detección del sistema operativo

2. **Actualización del Sistema**
   - `apt update && apt upgrade`
   - ` parrot-upgrade ` (si es Parrot OS)
   - Limpieza de paquetes obsoletos

3. **Menú Principal**
   - Presentación de categorías
   - Selección interactiva
   - Advertencias para opciones no recomendadas (Wine)

4. **Instalación**
   - Descarga de paquetes
   - Instalación secuencial
   - Verificación post-instalación

5. **Finalización**
   - Resumen de instalaciones
   - Recomendaciones
   - Opción de reinicio

## Próximos Pasos

- [ ] Crear script principal con estructura modular
- [ ] Implementar funciones de instalación para cada aplicación
- [ ] Añadir menú interactivo
- [ ] Implementar sistema de logs
- [ ] Probar en Parrot OS
- [ ] Añadir más distribuciones Linux
- [ ] Crear instalador gráfico (futuro)

## Notas Adicionales

### Métodos de Instalación
- **APT:** Para paquetes en repositorios oficiales
- **Flatpak/Snap:** Para aplicaciones no disponibles en repositorios
- **AppImage:** Como alternativa cuando sea necesario
- **Descarga directa:** Para software específico

### Seguridad
- Verificación de firmas GPG cuando sea posible
- Uso de repositorios oficiales
- Evitar scripts de terceros no verificados (nada recomendado)

---

**Versión:** 1.0  
**Última actualización:** Marzo 2026  
**Mantenedor:** Alastor
