#!/bin/bash
D='\n\033[0;33m-> '
O='\033[0;34m'
F='\033[0m'

echo -e "\n\033[0;33m--|${O} Instalación base $MSG ${F}\033[0;33m|--"


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

# Agregar repositorios
echo -e "${D}${O}Agregar repositorios${F}"
echo "dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo"
dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
echo "dnf config-manager --add-repo https://raw.githubusercontent.com/mdanieltg/init/main/fedora-repos/1password.repo"
dnf config-manager --add-repo https://raw.githubusercontent.com/mdanieltg/init/main/fedora-repos/1password.repo
echo "dnf config-manager --add-repo https://raw.githubusercontent.com/mdanieltg/init/main/fedora-repos/code.repo"
dnf config-manager --add-repo https://raw.githubusercontent.com/mdanieltg/init/main/fedora-repos/code.repo
echo "dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo"
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
echo "dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo"
dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo

# Instalar software restante
echo -e "${D}${O}Instalar software restante${F}"
echo "dnf install -y util-linux-user git-core zsh vim gh terminator firefox thunderbird dotnet-sdk-3.1 dotnet-sdk-5.0 sublime-text sublime-merge code 1password docker-ce docker-ce-cli"
dnf install -y util-linux-user git-core zsh vim gh terminator firefox thunderbird dotnet-sdk-3.1 dotnet-sdk-5.0 sublime-text sublime-merge code 1password docker-ce docker-ce-cli

# Habilitar servicio de Docker
echo -e "${D}${O}Habilitar servicio de Docker${F}"
echo "systemctl enable docker.service"
systemctl enable docker.service
echo "systemctl enable containerd.service"
systemctl enable containerd.service

# Actualizar sistema
echo -e "${D}${O}Actualizar paquetes${F}"
echo "dnf update -y"
dnf update -y

# Habilitar Flatpak
echo -e "${D}${O}Habilitar Flatpak${F}"
echo "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Instalar aplicaciones de Flatpak
echo -e "${D}${O}Instalar aplicaciones de Flatpak${F}"
echo "sudo -u $USR flatpak install --noninteractive flathub com.getpostman.Postman org.chromium.Chromium io.typora.Typora org.telegram.desktop com.spotify.Client"
sudo -u $USR flatpak install --noninteractive flathub com.getpostman.Postman org.chromium.Chromium io.typora.Typora org.telegram.desktop com.spotify.Client

# Cambiar shell a Zsh
echo -e "${D}${O}Cambiar shell a Zsh${F}"
echo "chsh -s \$(which zsh) $USR"
chsh -s $(which zsh) $USR

# Agregar usuario al grupo de Docker
echo -e "${D}${O}Agregar usuario al grupo de Docker${F}"
echo "usermod -aG docker $USR"
usermod -aG docker $USR


echo -e "\n\033[0;33m--|${O} ¡Finalizado!\033[0;33m |--${F}\n"
