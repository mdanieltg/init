#!/bin/bash

### NO UTILIZAR, NO HA SIDO PROBADO
### NO NOT USE, HASN'T BEEN TESTED

if [ $UID -eq 0 ]; then
	echo 'No debes ejecutarme con privilegios elevados o como root'
fi

echo 'sudo para comandos administrativos'
sudo -v

# Refrescar la caché de paquetes
sudo apt update

# Quitar snap
sudo apt purge -y snapd
sudo apt autoremove --purge

# Actualizar sistema
sudo apt upgrade -y

# Instalar herramientas CLI y librerías
sudo apt install -y git zsh vim curl apt-transport-https build-essential

# Actualizar alternativas
sudo update-aternatives --set editor $(which vim.basic)
sudo update-aternatives --set x-terminal-emulator $(which terminator)

# Agregar fuentes a /etc/apt/sources.list.d
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

# Obtener llaves
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
curl -sS https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

# El buen Node.js
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

# Instalar software faltante
sudo apt install -y dotnet-sdk-3.1 spotify-client nodejs yarn sublime-text meld terminator firefox firefox-locale-es geary

# Maicra
sudo dpkg -i https://launcher.mojang.com/download/Minecraft.deb

# Arreglar dependencias incumplidas
sudo apt install -f

# Limpiar
sudo apt clean
sudo apt autoremove --purge


## Configuraciones personales
chsh -s $(which zsh)

# SSH config
mkdir -m 700 "$HOME/.ssh"
curl -fsSL https://gist.githubusercontent.com/mdanieltg/0fb696bcb58718b28a03b4dcf1f8c2dd/raw/07973de1fc06a9bb73b6d3a7ff023d0e8c80728e/ssh-config | tee -a "$HOME/.ssh/config" > /dev/null

# Configurar Git
git config --global user.name "Daniel Medrano Huerta"
git config --global push.default simple
git config --global alias.br "branch"
git config --global alias.ca "commit -a"
git config --global alias.caa "commit --amend"
git config --global alias.cam "commit -am"
git config --global alias.ch "checkout"
git config --global alias.cm "commit -m"
git config --global alias.co "commit"
git config --global alias.lg "log --oneline"
git config --global alias.lgg "log --oneline --graph --decorate"
git config --global alias.lga "log --oneline --graph --all --decorate"
git config --global alias.st "status -s"
git config --global alias.sts "status"
git config --global core.editor "editor"
git config --global core.autocrlf input

# Configurar Vim
git clone https://github.com/mdanieltg/vim-profile.git "$HOME/.vim"
ln -sf "$HOME/.vim/vimrc" "$HOME/.vimrc"


## OHMYZ.SH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

#sed -i '' "$HOME/.zshrc"
