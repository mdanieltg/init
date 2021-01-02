#!/bin/bash
B='\033[1;36m'
D='\n\033[0;33m>> '
O='\033[0;34m'
F='\033[0m'

if [ $UID -eq 0 ]; then
	echo "No debes ejecutarme con privilegios elevados o como root"
fi

echo -e "${B}sudo${O} para comandos administrativos${F}"
sudo -v

# Refrescar la caché de paquetes
echo -e "${D}${O}Actualizar la caché de paquetes${F}"
sudo apt update

# Quitar Snap
echo -e "${D}${O}Quitar Snap${F}"
sudo apt autoremove --purge -y snapd

# Actualizar sistema
echo -e "${D}${O}Actualizar paquetes${F}"
sudo apt upgrade -y

# Instalar herramientas CLI y librerías
echo -e "${D}${O}Instalar herramientas CLI y librerías${F}"
sudo apt install -y git zsh vim curl apt-transport-https build-essential

# Instalar el repositorio de .NET
echo -e "${D}${O}Instalar el repositorio de .NET${F}"
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# Actualizar alternativas
echo -e "${D}${O}Actualizar alternativas${F}"
sudo update-alternatives --set editor $(which vim.basic)
sudo update-alternatives --set x-terminal-emulator $(which terminator)

# Agregar fuentes a /etc/apt/sources.list.d
echo -e "${D}${O}Agregar fuentes a /etc/apt/sources.list.d${F}"
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

# Obtener llaves
echo -e "${D}${O}Obtener llaves PGP${F}"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
curl -sS https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

# Instalar repositorio de Node.js 14
echo -e "${D}${O}Instalar repositorio de Node.js 14${F}"
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -

# Instalar software faltante
echo -e "${D}${O}Instalar software faltante${F}"
sudo apt install -y dotnet-sdk-5.0 spotify-client nodejs yarn sublime-text sublime-merge meld terminator firefox firefox-locale-es thunderbird thunderbird-locale-es

# Instalar Minecraft
echo -e "${D}${O}Instalar Minecraft${F}"
wget https://launcher.mojang.com/download/Minecraft.deb
sudo dpkg -i Minecraft.deb
rm Minecraft.deb

# Instalar VS Code
echo -e "${D}${O}Instalar VS Code${F}"
wget https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64 -O vscode.deb
sudo dpkg -i vscode.deb
rm vscode.deb

# Arreglar dependencias incumplidas
echo -e "${D}${O}Arreglar dependencias incumplidas (si existen)${F}"
sudo apt install -f

# Limpiar
echo -e "${D}${O}Limpiar${F}"
sudo apt clean
sudo apt autoremove --purge


## Configuraciones personales
echo -e "${D}${O}Configuraciones personales${F}"

# Cambiar shell a Zsh
echo -e "${D}${O}Cambiar shell a Zsh${F}"
chsh -s $(which zsh)

# Importar configuración SSH
echo -e "${D}${O}Importar configuración SSH${F}"
mkdir -m 700 "$HOME/.ssh"
curl -fsSL https://gist.githubusercontent.com/mdanieltg/0fb696bcb58718b28a03b4dcf1f8c2dd/raw/07973de1fc06a9bb73b6d3a7ff023d0e8c80728e/ssh-config | tee -a "$HOME/.ssh/config" > /dev/null

# Importar configuración de Git
echo -e "${D}${O}Importar configuración de Git${F}"
curl -fsSL https://gist.githubusercontent.com/mdanieltg/bc983d81cdcbf1340f345eb3fb87d8b7/raw/4464173ce2972f492f43520f200fc53fb6d36287/git-config.sh | sh -

# Importar configuración de Vim
echo -e "${D}${O}Importar configuración de Vim${F}"
git clone https://github.com/mdanieltg/vim-profile.git "$HOME/.vim"
ln -sf "$HOME/.vim/vimrc" "$HOME/.vimrc"


## Instalar Oh My Zsh
echo -e "${D}${O}Instalar Oh My Zsh${F}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# Instalar p10k
echo -e "${D}${O}Instalar p10k${F}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

#sed -i '' "$HOME/.zshrc"
