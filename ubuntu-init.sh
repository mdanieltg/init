#!/bin/bash
D='\n\033[0;33m-> '
O='\033[0;34m'
F='\033[0m'

# Detener el servicio de actualizaciones no supervisadas, ya que puede obstruir la instalación de los paquetes
echo -e "${D}${O}Deshabilitar las actualizaciones no supervisadas${F}"
echo "systemctl stop --now unattended-upgrades.service"
systemctl stop --now unattended-upgrades.service

# Refrescar la caché de paquetes
echo -e "${D}${O}Actualizar la caché de paquetes${F}"
echo "apt update"
apt update

# Instalar software base
echo -e "${D}${O}Instalar software base${F}"
echo "apt install -y curl apt-transport-https"
apt install -y curl apt-transport-https

# Agregar fuentes a /etc/apt/sources.list.d
echo -e "${D}${O}Agregar fuentes a /etc/apt/sources.list.d${F}"
echo "echo \"deb https://download.sublimetext.com/ apt/stable/\" \
| tee /etc/apt/sources.list.d/sublime-text.list"
echo "deb https://download.sublimetext.com/ apt/stable/" \
	| tee /etc/apt/sources.list.d/sublime-text.list

# Obtener llaves
echo -e "${D}${O}Obtener llaves PGP${F}"
echo "curl -sS \"https://download.sublimetext.com/sublimehq-pub.gpg\" | apt-key add -"
curl -sS "https://download.sublimetext.com/sublimehq-pub.gpg" | apt-key add -

# Instalar el repositorio de .NET
echo -e "${D}${O}Instalar el repositorio de .NET${F}"
echo "wget \"https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb\""
wget "https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb"
echo "dpkg -i packages-microsoft-prod.deb"
dpkg -i packages-microsoft-prod.deb
echo "rm packages-microsoft-prod.deb"
rm packages-microsoft-prod.deb

# Instalar repositorio de Node.js 14
echo -e "${D}${O}Instalar repositorio de Node.js 14${F}"
echo "curl -sL \"https://deb.nodesource.com/setup_14.x\" | bash -"
curl -sL "https://deb.nodesource.com/setup_14.x" | bash -

# Refrescar la caché de paquetes
echo -e "${D}${O}Actualizar la caché de paquetes nuevamente${F}"
echo "apt update"
apt update

# Instalar software restante
echo -e "${D}${O}Instalar software restante${F}"
echo "apt install -y git zsh vim build-essential meld terminator firefox firefox-locale-es thunderbird thunderbird-locale-es dotnet-sdk-3.1 dotnet-sdk-5.0 nodejs sublime-text sublime-merge"
apt install -y git zsh vim build-essential meld terminator firefox firefox-locale-es thunderbird thunderbird-locale-es dotnet-sdk-3.1 dotnet-sdk-5.0 nodejs sublime-text sublime-merge

# Instalar Minecraft
echo -e "${D}${O}Instalar Minecraft${F}"
echo "wget \"https://launcher.mojang.com/download/Minecraft.deb\""
wget "https://launcher.mojang.com/download/Minecraft.deb"
echo "dpkg -i Minecraft.deb"
dpkg -i Minecraft.deb
echo "rm Minecraft.deb"
rm Minecraft.deb

# Instalar VS Code
echo -e "${D}${O}Instalar VS Code${F}"
echo "wget -O vscode.deb \"https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64\""
wget -O vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
echo "dpkg -i vscode.deb"
dpkg -i vscode.deb
echo "rm vscode.deb"
rm vscode.deb

# Arreglar dependencias incumplidas
echo -e "${D}${O}Arreglar dependencias incumplidas (si existen)${F}"
echo "apt install -f -y"
apt install -f -y

# Actualizar sistema
echo -e "${D}${O}Actualizar paquetes${F}"
echo "apt upgrade -y"
apt upgrade -y

# Limpiar
echo -e "${D}${O}Limpiar${F}"
echo "apt autoremove --purge"
apt autoremove --purge
echo "apt clean"
apt clean

# Actualizar alternativas
echo -e "${D}${O}Actualizar alternativas${F}"
echo "update-alternatives --set editor $(which vim.basic)"
update-alternatives --set editor $(which vim.basic)
echo "update-alternatives --set x-terminal-emulator $(which terminator)"
update-alternatives --set x-terminal-emulator $(which terminator)

# Cambiar shell a Zsh
echo -e "${D}${O}Cambiar shell a Zsh${F}"
echo "chsh -s \$(which zsh) $USR"
chsh -s $(which zsh) $USR
