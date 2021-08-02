#!/bin/bash
D='\n\033[0;33m-> '
O='\033[0;34m'
F='\033[0m'

echo -e "\n\033[0;33m--|${O} Instalación base $MSG ${F}\033[0;33m|--"


# Instalar software base
echo -e "${D}${O}Instalar software base${F}"
dnf install -y curl dnf-plugins-core

# Obtener llaves
echo -e "${D}${O}Obtener llaves PGP${F}"
rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
rpm -v --import https://packages.microsoft.com/keys/microsoft.asc
rpm -v --import https://downloads.1password.com/linux/keys/1password.asc

# Agregar repositorios
echo -e "${D}${O}Agregar repositorios${F}"
dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
dnf config-manager --add-repo https://github.com/mdanieltg/init/raw/main/fedora-repos/1password.repo
dnf config-manager --add-repo https://github.com/mdanieltg/init/raw/main/fedora-repos/code.repo
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo

# Instalar software restante
echo -e "${D}${O}Instalar software restante${F}"
dnf install -y util-linux-user git-core zsh vim gh terminator firefox thunderbird dotnet-sdk-3.1 dotnet-sdk-5.0 sublime-text sublime-merge code 1password docker-ce docker-ce-cli

# Habilitar servicio de Docker
echo -e "${D}${O}Habilitar servicio de Docker${F}"
systemctl enable docker.service
systemctl enable containerd.service

# Actualizar sistema
echo -e "${D}${O}Actualizar paquetes${F}"
dnf update -y

# Habilitar Flatpak
echo -e "${D}${O}Habilitar Flatpak${F}"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Instalar aplicaciones de Flatpak
echo -e "${D}${O}Instalar aplicaciones de Flatpak${F}"
sudo -u $USR flatpak install --noninteractive flathub com.getpostman.Postman org.chromium.Chromium io.typora.Typora org.telegram.desktop com.spotify.Client

# Cambiar shell a Zsh
echo -e "${D}${O}Cambiar shell a Zsh${F}"
chsh -s $(which zsh) $USR

# Agregar usuario al grupo de Docker
echo -e "${D}${O}Agregar usuario al grupo de Docker${F}"
usermod -aG docker $USR


echo -e "\n\033[0;33m--|${O} ¡Finalizado!\033[0;33m |--${F}\n"
