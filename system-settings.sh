#!/bin/bash

# Detener el servicio de actualizaciones no supervisadas, ya que puede obstruir la instalación de los paquetes
echo -e "${D}${O}Deshabilitar las actualizaciones no supervisadas${F}"
systemctl stop unattended-upgrades.service

# Refrescar la caché de paquetes
echo -e "${D}${O}Actualizar la caché de paquetes${F}"
apt update

# Quitar Snap
echo -e "${D}${O}Quitar Snap${F}"
systemctl stop snapd
apt autoremove --purge -y snapd

# Instalar software base
echo -e "${D}${O}Instalar software base${F}"
apt install -y curl apt-transport-https

# Agregar fuentes a /etc/apt/sources.list.d
echo -e "${D}${O}Agregar fuentes a /etc/apt/sources.list.d${F}"
echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
echo "deb http://repository.spotify.com stable non-free" | tee /etc/apt/sources.list.d/spotify.list

# Obtener llaves
echo -e "${D}${O}Obtener llaves PGP${F}"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | apt-key add -
curl -sS https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -

# Instalar el repositorio de .NET
echo -e "${D}${O}Instalar el repositorio de .NET${F}"
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# Instalar repositorio de Node.js 14
echo -e "${D}${O}Instalar repositorio de Node.js 14${F}"
curl -sL https://deb.nodesource.com/setup_14.x | bash -

# Refrescar la caché de paquetes
echo -e "${D}${O}Actualizar la caché de paquetes nuevamente${F}"
apt update

# Instalar software restante
echo -e "${D}${O}Instalar software restante${F}"
apt install -y git zsh vim build-essential meld terminator firefox firefox-locale-es thunderbird thunderbird-locale-es dotnet-sdk-5.0 spotify-client nodejs yarn sublime-text sublime-merge

# Instalar Minecraft
echo -e "${D}${O}Instalar Minecraft${F}"
wget https://launcher.mojang.com/download/Minecraft.deb
dpkg -i Minecraft.deb
rm Minecraft.deb

# Instalar VS Code
echo -e "${D}${O}Instalar VS Code${F}"
wget -O vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
dpkg -i vscode.deb
rm vscode.deb

# Arreglar dependencias incumplidas
echo -e "${D}${O}Arreglar dependencias incumplidas (si existen)${F}"
apt install -f -y

# Actualizar sistema
echo -e "${D}${O}Actualizar paquetes${F}"
apt upgrade -y

# Limpiar
echo -e "${D}${O}Limpiar${F}"
apt autoremove --purge
apt clean

# Actualizar alternativas
echo -e "${D}${O}Actualizar alternativas${F}"
update-alternatives --set editor $(which vim.basic)
update-alternatives --set x-terminal-emulator $(which terminator)

# Cambiar shell a Zsh
echo -e "${D}${O}Cambiar shell a Zsh${F}"
chsh -s $(which zsh) $USR
