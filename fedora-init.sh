#!/bin/bash
D='\n\033[0;33m-> '
O='\033[0;34m'
F='\033[0m'

# Instalar software base
echo -e "${D}${O}Instalar software base${F}"
echo "dnf install -y curl dnf-plugins-core"
dnf install -y curl dnf-plugins-core

# Obtener llaves
echo -e "${D}${O}Obtener llaves PGP${F}"
echo "rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg"
rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
echo "rpm -v --import https://packages.microsoft.com/keys/microsoft.asc"
rpm -v --import https://packages.microsoft.com/keys/microsoft.asc
echo "rpm -v --import https://downloads.1password.com/linux/keys/1password.asc"
rpm -v --import https://downloads.1password.com/linux/keys/1password.asc

# Agregar fuentes a /etc/apt/sources.list.d
echo -e "${D}${O}Agregar fuentes a /etc/apt/sources.list.d${F}"
echo "dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo"
dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
echo "dnf config-manager --add-repo https://raw.githubusercontent.com/mdanieltg/init/develop/fedora-repos/1password.repo"
dnf config-manager --add-repo https://raw.githubusercontent.com/mdanieltg/init/develop/fedora-repos/1password.repo
echo "dnf config-manager --add-repo https://raw.githubusercontent.com/mdanieltg/init/develop/fedora-repos/code.repo"
dnf config-manager --add-repo https://raw.githubusercontent.com/mdanieltg/init/develop/fedora-repos/code.repo
echo "dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo"
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

# Instalar software restante
echo -e "${D}${O}Instalar software restante${F}"
echo "dnf install -y git-core zsh vim terminator firefox firefox-locale-es thunderbird thunderbird-locale-es dotnet-sdk-3.1 dotnet-sdk-5.0 nodejs npm sublime-text sublime-merge code 1password docker-ce docker-ce-cli"
dnf install -y git-core zsh vim terminator firefox firefox-locale-es thunderbird thunderbird-locale-es dotnet-sdk-3.1 dotnet-sdk-5.0 nodejs npm sublime-text sublime-merge code 1password docker-ce docker-ce-cli

# Actualizar sistema
echo -e "${D}${O}Actualizar paquetes${F}"
echo "dnf update -y"
#dnf update -y

# Actualizar alternativas
echo -e "${D}${O}Actualizar alternativas${F}"
echo "alternatives --install editor \$(which vim.basic)"
alternatives --install editor $(which vim.basic)

# Cambiar shell a Zsh
echo -e "${D}${O}Cambiar shell a Zsh${F}"
echo "chsh -s \$(which zsh) $USR"
chsh -s $(which zsh) $USR

# Agregar usuario al grupo de Docker
echo -e "${D}${O}Agregar usuario al grupo de Docker${F}"
echo "usermod -aG docker $USR"
usermod -aG docker $USR
