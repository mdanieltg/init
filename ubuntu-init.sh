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

# Instalar utilidades
echo -e "${D}${O}Instalar utilidades${F}"
echo "apt install -y curl apt-transport-https"
apt install -y curl apt-transport-https

# Obtener llaves
echo -e "${D}${O}Obtener llaves PGP${F}"
echo "curl -sS \"https://download.sublimetext.com/sublimehq-pub.gpg\" | apt-key add -"
curl -sS "https://download.sublimetext.com/sublimehq-pub.gpg" | apt-key add -
echo "curl -sS \"https://downloads.1password.com/linux/keys/1password.asc\" | apt-key add -"
curl -sS "https://downloads.1password.com/linux/keys/1password.asc" | apt-key add -
echo "curl -fsSL \"https://download.docker.com/linux/ubuntu/gpg\" | apt-key add -"
curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" | apt-key add -

# Agregar fuentes a /etc/apt/sources.list.d
echo -e "${D}${O}Agregar fuentes a /etc/apt/sources.list.d${F}"
echo "echo \"deb https://download.sublimetext.com/ apt/stable/\" \
| tee /etc/apt/sources.list.d/sublime-text.list"
echo "deb https://download.sublimetext.com/ apt/stable/" \
	| tee /etc/apt/sources.list.d/sublime-text.list
echo "echo \"deb [arch=amd64] https://downloads.1password.com/linux/debian/amd64 stable main\" \
| tee /etc/apt/sources.list.d/1password.list"
echo "deb [arch=amd64] https://downloads.1password.com/linux/debian/amd64 stable main" \
	| tee /etc/apt/sources.list.d/1password.list
echo "echo \"deb [arch=amd64] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable\" \
| tee /etc/apt/sources.list.d/docker.list > /dev/null"
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
	| tee /etc/apt/sources.list.d/docker.list > /dev/null

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
echo "apt install -y git zsh vim build-essential terminator firefox firefox-locale-es thunderbird thunderbird-locale-es dotnet-sdk-3.1 dotnet-sdk-5.0 nodejs sublime-text sublime-merge 1password docker-ce docker-ce-cli containerd.io"
apt install -y git zsh vim build-essential terminator firefox firefox-locale-es thunderbird thunderbird-locale-es dotnet-sdk-3.1 dotnet-sdk-5.0 nodejs sublime-text sublime-merge 1password docker-ce docker-ce-cli containerd.io

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
echo "apt autoremove --purge -y"
apt autoremove --purge -y
echo "apt clean -y"
apt clean -y

# Actualizar alternativas
echo -e "${D}${O}Actualizar alternativas${F}"
echo "update-alternatives --set editor \$(which vim.basic)"
update-alternatives --set editor $(which vim.basic)
echo "update-alternatives --set x-terminal-emulator \$(which terminator)"
update-alternatives --set x-terminal-emulator $(which terminator)

# Cambiar shell a Zsh
echo -e "${D}${O}Cambiar shell a Zsh${F}"
echo "chsh -s \$(which zsh) $USR"
chsh -s $(which zsh) $USR

# Agregar usuario al grupo de Docker
echo -e "${D}${O}Agregar usuario al grupo de Docker${F}"
echo "usermod -aG docker $USR"
usermod -aG docker $USR
