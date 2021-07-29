#!/bin/bash
CONFIG=$HOME/.config
LOCAL=$HOME/.local
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

B='\033[1;36m'
D='\n\033[0;33m>> '
O='\033[0;34m'
F='\033[0m'

if [ $UID -eq 0 ]; then
	echo -e "\033[0;31mNo ejecutar con privilegios elevados o como root${F}"
	exit 1
fi


## Configuración del usuario
echo -e "\n\n${D}${O}Configuraciones personales${F}\n"

# Importar configuración SSH
echo -e "${D}${O}Importar configuración SSH${F}"
mkdir -m 700 "$HOME/.ssh"
curl -fsSL https://gist.github.com/mdanieltg/0fb696bcb58718b28a03b4dcf1f8c2dd/raw \
	| tee -a "$HOME/.ssh/config" >/dev/null

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
mkdir -p "$CONFIG/sublime-text/Packages/User"
curl -fsSL https://gist.github.com/mdanieltg/12793d5354d546d4a0b8d31f8cdc4a08/raw \
	| tee "$CONFIG/sublime-text/Packages/User/Preferences.sublime-settings" >/dev/null

# Importar configuración de Sublime Merge
echo -e "${D}${O}Importar configuración de Sublime Merge${F}"
mkdir -p "$CONFIG/sublime-merge/Packages/User"
curl -fsSL https://gist.github.com/mdanieltg/f415269ddcf22f3b06eaaf341aea9b49/raw \
	| tee "$CONFIG/sublime-merge/Packages/User/Preferences.sublime-settings" >/dev/null

# Importar configuración de VS Code
echo -e "${D}${O}Importar configuración de VS Code${F}"
mkdir -p "$CONFIG/Code/User"
curl -fsSL https://gist.github.com/mdanieltg/dcd9678504da9137d45e92fa16a76df1/raw \
	| tee "$CONFIG/Code/User/settings.json" >/dev/null

curl -fsSL https://gist.github.com/mdanieltg/ed2c2f10829db4f78b1473d6b990eeb7/raw \
	| tee "$CONFIG/Code/User/keybindings.json" >/dev/null

# Importar configuración de Terminator
echo -e "${D}${O}Importar configuración de Terminator${F}"
mkdir -p "$CONFIG/terminator"
curl -fsSL https://gist.github.com/mdanieltg/4eab7f25c2d334058e769952ca03f6af/raw \
	| tee "$CONFIG/terminator/config" >/dev/null

# Importar fuentes


## Instalar Oh My Zsh
echo -e "${D}${O}Instalar Oh My Zsh${F}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended

echo -e "${D}${O}Instalar plugins${F}"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# Instalar p10k
echo -e "${D}${O}Instalar p10k${F}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

# Configurar Zsh
echo -e "${D}${O}Configurar Zsh${F}"
curl -fsSL https://raw.githubusercontent.com/mdanieltg/zsh-profile/master/zshrc-omz-p10k \
	| tee "$HOME/.zshrc" >/dev/null


echo -e "\n¡Finalizado!"
