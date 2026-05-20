# 🐧 EasyLinux - Automatic Installer

[![Typing SVG](https://readme-typing-svg.demolab.com?font=Consolas&size=18&duration=500&pause=500&color=04B305&background=00000049&multiline=true&width=500&height=250&lines=%24+.%2Finstall.sh+--developer;%5BINFO%5D+Loading+profile%3A+developer;%5BINFO%5D+Installing+development+toolchain...;%5BINFO%5D+Making+a+productive+system...;%5BLOAD%5D+Finishing+details+...;%5BSUCCESS%5D+Environment+bootstrap+completed)](https://git.io/typing-svg)

[![Status](https://img.shields.io/badge/status-active-success.svg)](https://github.com/your-user/EasyLinux)
[![Version](https://img.shields.io/badge/version-2.0-blue.svg)](https://github.com/your-user/EasyLinux)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

Automatic setup project for Debian-based Linux distributions. Perfect for quickly configuring a fresh system with applications and development tools, now with a modular architecture for easier maintenance and scalability.

---

# 📋 Table of Contents

* [Features](#-features)
* [Requirements](#-requirements)
* [Installation and Usage](#-installation-and-usage)
* [Available Software](#-available-software)
* [Screenshots](#-screenshots)
* [Troubleshooting](#-troubleshooting)
* [Contributing](#-contributing)
* [License](#-license)

---

# ✨ Features

* **🚀 Fast Installation**: Automates installation of your favorite applications
* **🎯 Interactive Menu**: User-friendly menu-based interface
* **📊 Progress Tracking**: Real-time installation progress
* **🔍 System Checks**: Verifies permissions, internet connection, and OS compatibility
* **📝 Full Logging**: All operations are saved into log files
* **🎨 Colored Interface**: Improved readability with colored output
* **🔐 Secure**: Does not require running as root, requests sudo only when needed
* **📦 Multiple Sources**: Installs from APT, Flatpak, direct downloads, and more
* **🧩 Modular Architecture**: Functions, modules, profiles, and catalogs separated cleanly
* **⚙️ Declarative Profiles**: Reusable setup profiles and package catalogs
* **🛡️ Safer Install Logic**: Strict Bash mode, centralized error handling, and idempotent installs

---

# 🔧 Requirements

## Supported Operating Systems

* Parrot OS (recommended)
* Debian 11+ / Ubuntu 20.04+
* Linux Mint 20+
* Any Debian-based distribution

## Hardware Requirements

* At least 5GB of free disk space
* Active internet connection
* 64-bit processor (amd64)

## Permissions

* User with sudo privileges
* Do not run as root

---

# 🚀 Installation and Usage

## Method 1: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/your-user/EasyLinux.git

# Enter the project directory
cd EasyLinux

# Make the installer executable
chmod +x install.sh

# Run the installer
./install.sh
```

---

# ⚡ Running with Profiles and Flags

```bash
# Install everything without category menus
./install.sh --all

# Developer profile
./install.sh --developer

# Custom declarative profile
./install.sh --profile developer

# Desktop profile
./install.sh --desktop

# Non-interactive confirmation mode
./install.sh --developer --yes

# Skip initial apt update
./install.sh --no-update
```

> Note: the old "one-liner" direct download method is no longer recommended because the installer now uses multiple modules and configuration files.

---

# 🧩 Declarative Profiles

Profiles are stored inside:

```text
config/profiles/*.conf
```

and executed in declarative steps.

Example profile:

```bash
PROFILE_DESCRIPTION="Full development stack"

PROFILE_CATALOGS=(
   terminal-base
   development-base
)

PROFILE_STEPS=(
   install_vscode
   install_java
)

PROFILE_APT_PACKAGES=(
   shellcheck
)

PROFILE_FLATPAK_APPS=(
   "com.github.tchx84.Flatseal|Flatseal"
)

PROFILE_VSCODE_EXTENSIONS=(
   "ms-python.python|Python"
)
```

You can create your own profile, for example:

```text
config/profiles/custom.conf
```

and run it with:

```bash
./install.sh --profile custom
```

---

# Supported Profile Keys

| Key                         | Description                                                       |                |
| --------------------------- | ----------------------------------------------------------------- | -------------- |
| `PROFILE_CATALOGS`          | Reusable catalogs defined in `config/catalogs/*.conf`             |                |
| `PROFILE_STEPS`             | Existing installer functions (example: `install_all_development`) |                |
| `PROFILE_APT_PACKAGES`      | APT package names                                                 |                |
| `PROFILE_FLATPAK_APPS`      | List of `"appId                                                   | Display Name"` |
| `PROFILE_VSCODE_EXTENSIONS` | List of `"extensionId                                             | Display Name"` |

---

# 📚 Catalog Example

Example catalog:

```bash
# config/catalogs/development-base.conf

CATALOG_DESCRIPTION="Base development tooling"

CATALOG_STEPS=(
   install_python
   install_cpp
   install_go
)

CATALOG_VSCODE_EXTENSIONS=(
   "ms-python.python|Python"
)
```

---

# 🏗️ Project Structure

```text
EasyLinux/
├── install.sh
├── functions/
├── modules/
├── config/
│   ├── profiles/
│   └── catalogs/
└── logs/
```

---

# 📦 Available Software

# 🌐 Web Browsers

| Browser                | Description                                       | Installation Method       |
| ---------------------- | ------------------------------------------------- | ------------------------- |
| **Brave**              | Privacy-focused browser with built-in ad blocking | APT (official repository) |
| **LibreWolf**          | Firefox without telemetry or trackers             | APT (official repository) |
| **Floorp**             | Firefox-based browser with advanced features      | Flatpak                   |
| **Chromium/Supremium** | Open-source Chrome-based browser                  | APT/Flatpak               |

---

# 💬 Communication Applications

| Application     | Description                                     | Installation Method |
| --------------- | ----------------------------------------------- | ------------------- |
| **Discord**     | Communication platform for communities          | Flatpak/DEB         |
| **Thunderbird** | Open-source email client                        | APT                 |
| **Session**     | Privacy-focused messenger without phone numbers | Direct DEB          |

---

# 📄 Productivity

| Application     | Description                                         | Installation Method |
| --------------- | --------------------------------------------------- | ------------------- |
| **LibreOffice** | Complete office suite (Writer, Calc, Impress, etc.) | APT                 |

---

# 👨‍💻 Development Tools

## Code Editor

* **Visual Studio Code** — Full-featured IDE with extension support

## Languages and Toolchains

| Tool        | Description                                | Versions             |
| ----------- | ------------------------------------------ | -------------------- |
| **Python**  | Interpreted language + pip + venv          | Latest 3.x           |
| **C++**     | gcc/g++ compiler + build-essential + CMake | Latest               |
| **Java**    | OpenJDK                                    | 17 LTS / 21 LTS / 25 |
| **Node.js** | JavaScript runtime + npm                   | LTS                  |
| **Go**      | Efficient concurrent language by Google    | Latest               |
| **Rust**    | Safe and fast systems language + Cargo     | Latest (via rustup)  |
| **Ruby**    | Dynamic language + RubyGems                | Latest               |
| **Dart**    | Google language for mobile/web apps        | Latest               |

---

# 🛠️ Additional Tools

| Tool                | Description                                 | Installation Method       |
| ------------------- | ------------------------------------------- | ------------------------- |
| **Git**             | Distributed version control system          | APT                       |
| **Docker**          | Container platform + Docker Compose         | APT (official repository) |
| **htop**            | Interactive process monitor                 | APT                       |
| **fastfetch**       | Modern system information tool              | APT                       |
| **tree**            | Directory structure viewer                  | APT                       |
| **vim**             | Advanced text editor                        | APT                       |
| **tmux**            | Terminal multiplexer                        | APT                       |
| **curl/wget**       | Download utilities                          | APT                       |
| **net-tools**       | Network utilities (ifconfig, netstat, etc.) | APT                       |
| **build-essential** | Essential compilers and build tools         | APT                       |

---

# ⚠️ Windows Compatibility (NOT RECOMMENDED)

> **⚠️ WARNING:** This option is not recommended. Native Linux applications are strongly preferred.
>
> 📚 Additional documentation:
>
> * `WINE_ALTERNATIVES.md` — Native alternatives to Windows software
> * `WINE_GUIDE.md` — Technical Wine setup guide

| Tool            | Description                                  | Installation Method |
| --------------- | -------------------------------------------- | ------------------- |
| **Wine**        | Compatibility layer for Windows applications | APT                 |
| **Winetricks**  | Windows component manager                    | APT                 |
| **PlayOnLinux** | Graphical Wine frontend                      | APT                 |

## Limitations

* ❌ May introduce system instability
* ❌ Lower performance than native Linux apps
* ❌ Does not guarantee all applications will work
* ❌ Higher resource consumption

---

# 🖥️ Startup Banner

```text
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║                      EASY LINUX INSTALLER                      ║
║                                                                ║
║            Automatic setup for your new Linux system           ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
```

---

# 🧭 Main Menu

```text
═══════════════════════════════════════════════════════════════
                     MAIN MENU
═══════════════════════════════════════════════════════════════

  1) Install Browsers
  2) Install Applications
  3) Install Development Tools
  4) Install Additional Tools (Git, Docker, etc.)
  5) Windows Compatibility (⚠️ NOT RECOMMENDED)
  6) Install EVERYTHING (without Wine)
  0) Exit

Select an option [0-6]:
```

---

# 🛠️ Troubleshooting

## Script Has No Execute Permissions

```bash
chmod +x install.sh
```

---

## Sudo Permission Errors

Make sure your user belongs to the sudo group:

```bash
sudo usermod -aG sudo $USER
# Log out and back in
```

---

## Internet Connection Error

Check connectivity:

```bash
curl -Is https://deb.debian.org
```

---

## Flatpak Not Installed

The installer can automatically install Flatpak, but you can also install it manually:

```bash
sudo apt install flatpak

flatpak remote-add --if-not-exists flathub \
https://flathub.org/repo/flathub.flatpakrepo
```

---

## View Installation Logs

Logs are stored in:

```text
~/.easylinux/logs/
```

Useful commands:

```bash
# Show latest log
ls -lt ~/.easylinux/logs/ | head -n 2

# Read a specific log
cat ~/.easylinux/logs/install_YYYYMMDD_HHMMSS.log

# Show recent errors
grep ERROR ~/.easylinux/logs/install_*.log | tail -n 20
```

---

## An Application Failed to Install

1. Review the corresponding log
2. Try installing manually:

```bash
sudo apt update
sudo apt install package-name
```

3. Verify repositories are configured correctly

---

## System Fails to Update

```bash
# Clean apt cache
sudo apt clean
sudo apt autoclean

# Refresh package lists
sudo apt update

# Full upgrade
sudo apt full-upgrade
```

---

# 🍷 Wine Troubleshooting

## Wine Does Not Install Correctly

```bash
# Check 32-bit architecture support
dpkg --print-foreign-architectures

# If i386 is missing:
sudo dpkg --add-architecture i386
sudo apt update

# Reinstall Wine
sudo apt install --reinstall wine wine32 wine64
```

---

## A Windows Application Does Not Work

1. **Check compatibility**

   * [https://appdb.winehq.org/](https://appdb.winehq.org/)

2. **Install dependencies with Winetricks**

```bash
winetricks
```

3. **Use PlayOnLinux**

   * Easier Wine version management
   * Better support for complex applications

4. **Look for native alternatives**

   * Native Linux applications are always preferred

---

## Fully Remove Wine

```bash
sudo apt remove --purge wine wine32 wine64 winetricks playonlinux

sudo apt autoremove

rm -rf ~/.wine
rm -rf ~/.PlayOnLinux
```

---

# 📁 File Structure

```text
EasyLinux/
├── install.sh
├── README.md
├── README-ES.md
├── WINE_ALTERNATIVES.md
├── WINE_GUIDE.md
└── logs/
    └── install_*.log
```

---

# 🤝 Contributing

Contributions are welcome.

## Workflow

1. Fork the project
2. Create a feature branch:

```bash
git checkout -b feature/NewApplication
```

3. Commit changes:

```bash
git commit -m "Add new application"
```

4. Push the branch:

```bash
git push origin feature/NewApplication
```

5. Open a Pull Request

---

# Adding a New Application

Example wrapper-based installation function:

```bash
install_myapp() {

    install_apt "myapp" "MyApp"
}
```

---

# 📝 Important Notes

* Do not run the installer as root
* Review logs for debugging
* Internet connection is required during installation
* Installation time depends on selected packages
* Rebooting after a full install is recommended
* Wine is strongly discouraged unless absolutely necessary

---

# 🔜 Planned Features

* [ ] Support for more distributions (Arch, Fedora)
* [ ] GUI frontend with Zenity/YAD
* [ ] YAML configuration support
* [ ] Fully unattended mode
* [ ] Backup and restore system configuration
* [ ] Custom setup profiles
* [ ] Theme and desktop customization
* [ ] Automatic dotfiles deployment

---

# 📜 License

This project is licensed under the MIT License — see the `LICENSE` file for details.

---

# 👤 Author

**Alastor**

* GitHub: `@your-user`

---

# 🙏 Acknowledgements

* Open-source community
* Developers of included applications
* Users contributing feedback and improvements

---

<div align="center">

**⭐ If this project helped you, consider giving it a star ⭐**

Made with ❤️ for the Linux community

</div>
