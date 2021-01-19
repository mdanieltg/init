#!/bin/bash
CONFIG=$HOME/.config
LOCAL=$HOME/.local

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
sudo systemctl stop snapd
sudo apt autoremove --purge -y snapd

# Instalar software base
echo -e "${D}${O}Instalar software base${F}"
sudo apt install -y curl apt-transport-https

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

# Instalar el repositorio de .NET
echo -e "${D}${O}Instalar el repositorio de .NET${F}"
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# Instalar repositorio de Node.js 14
echo -e "${D}${O}Instalar repositorio de Node.js 14${F}"
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -

# Instalar software restante
echo -e "${D}${O}Instalar software restante${F}"
sudo apt install -y git zsh vim build-essential meld terminator firefox firefox-locale-es thunderbird thunderbird-locale-es dotnet-sdk-5.0 spotify-client nodejs yarn sublime-text sublime-merge

# Instalar Minecraft
echo -e "${D}${O}Instalar Minecraft${F}"
wget https://launcher.mojang.com/download/Minecraft.deb
sudo dpkg -i Minecraft.deb
rm Minecraft.deb

# Instalar VS Code
echo -e "${D}${O}Instalar VS Code${F}"
wget -O vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
sudo dpkg -i vscode.deb
rm vscode.deb

# Arreglar dependencias incumplidas
echo -e "${D}${O}Arreglar dependencias incumplidas (si existen)${F}"
sudo apt install -f -y

# Actualizar sistema
echo -e "${D}${O}Actualizar paquetes${F}"
sudo apt upgrade -y

# Limpiar
echo -e "${D}${O}Limpiar${F}"
sudo apt autoremove --purge
sudo apt clean

# Actualizar alternativas
echo -e "${D}${O}Actualizar alternativas${F}"
sudo update-alternatives --set editor $(which vim.basic)
sudo update-alternatives --set x-terminal-emulator $(which terminator)


## Configuraciones personales
echo -e "${D}${O}Configuraciones personales${F}"

# Cambiar shell a Zsh
echo -e "${D}${O}Cambiar shell a Zsh${F}"
sudo chsh -s $(which zsh) $USER

# Importar configuración SSH
echo -e "${D}${O}Importar configuración SSH${F}"
mkdir -m 700 "$HOME/.ssh"
curl -fsSL https://gist.github.com/mdanieltg/0fb696bcb58718b28a03b4dcf1f8c2dd/raw \
	| tee -a "$HOME/.ssh/config" > /dev/null

# Importar configuración de Git
echo -e "${D}${O}Importar configuración de Git${F}"
curl -fsSL https://gist.github.com/mdanieltg/bc983d81cdcbf1340f345eb3fb87d8b7/raw \
	| sh -

# Importar configuración de Vim
echo -e "${D}${O}Importar configuración de Vim${F}"
git clone https://github.com/mdanieltg/vim-profile.git "$HOME/.vim"
ln -sf "$HOME/.vim/vimrc" "$HOME/.vimrc"

# Importar configuración de Sublime Text
echo -e "${D}${O}Importar configuración de Sublime Text${F}"
curl -fsSL https://gist.github.com/mdanieltg/12793d5354d546d4a0b8d31f8cdc4a08/raw \
	| tee "$CONFIG/sublime-text-3/Packages/User/Preferences.sublime-settings" > /dev/null

# Importar configuración de Sublime Merge
echo -e "${D}${O}Importar configuración de Sublime Merge${F}"
curl -fsSL https://gist.github.com/mdanieltg/f415269ddcf22f3b06eaaf341aea9b49/raw \
	| tee "$CONFIG/sublime-merge/Packages/User/Preferences.sublime-settings" > /dev/null

# Importar configuración de VS Code
echo -e "${D}${O}Importar configuración de VS Code${F}"
curl -fsSL https://gist.github.com/mdanieltg/dcd9678504da9137d45e92fa16a76df1/raw \
	| tee "$CONFIG/Code/User/settings.json" > /dev/null

curl -fsSL https://gist.github.com/mdanieltg/ed2c2f10829db4f78b1473d6b990eeb7/raw \
	| tee "$CONFIG/Code/User/keybindings.json" > /dev/null

# Importar configuración de Terminator
echo -e "${D}${O}Importar configuración de Terminator${F}"
curl -fsSL https://gist.github.com/mdanieltg/4eab7f25c2d334058e769952ca03f6af/raw \
	| tee "$CONFIG/terminator/config" > /dev/null

# Importar fuentes


## Instalar Oh My Zsh
echo -e "${D}${O}Instalar Oh My Zsh${F}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Instalar p10k
echo -e "${D}${O}Instalar p10k${F}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k

#sed -i '' "$HOME/.zshrc"


echo "¡Finalizado!"
