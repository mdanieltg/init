#!/bin/bash
CONFIG="$HOME/.config"
LOCAL="$HOME/.local"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
GIST="https://gist.github.com/mdanieltg"
GH="https://github.com/mdanieltg"

B='\033[1;36m'
D='\033[0;33m-> '
O='\033[0;34m'
F='\033[0m'

if [ $UID -eq 0 ]; then
	echo -e "\033[0;31mNo ejecutar con privilegios elevados o como root${F}"
	exit 1
fi

## Configuración del usuario
echo -e "\n\033[0;33m--|${O} Configuraciones personales ${F}\033[0;33m|--"


# Importar configuración SSH
echo -e "\n${D}${O}Importar configuración SSH${F}"
echo "mkdir -m 700 '$HOME/.ssh'"
mkdir -m 700 "$HOME/.ssh"
echo "curl -fsSL '$GIST/0fb696bcb58718b28a03b4dcf1f8c2dd/raw' \
| tee -a '$HOME/.ssh/config' >/dev/null"
curl -fsSL "$GIST/0fb696bcb58718b28a03b4dcf1f8c2dd/raw" \
	| tee -a "$HOME/.ssh/config" >/dev/null


# Importar configuración de Git
echo -e "\n${D}${O}Importar configuración de Git${F}"
echo "curl -fsSL '$GIST/bc983d81cdcbf1340f345eb3fb87d8b7/raw' \
| sh -"
curl -fsSL "$GIST/bc983d81cdcbf1340f345eb3fb87d8b7/raw" | sh -


# Importar configuración de Vim
echo -e "\n${D}${O}Importar configuración de Vim${F}"
echo "git clone $GH/vim-profile.git '$HOME/.vim'"
git clone $GH/vim-profile.git "$HOME/.vim"
echo "ln -sf '$HOME/.vim/vimrc' '$HOME/.vimrc'"
ln -sf "$HOME/.vim/vimrc" "$HOME/.vimrc"


# Importar configuración de Sublime Text
SUBL="$CONFIG/sublime-text/Packages/User"
echo -e "\n${D}${O}Importar configuración de Sublime Text${F}"
echo "mkdir -p '$SUBL'"
mkdir -p "$SUBL"
echo "curl -fsSL '$GIST/12793d5354d546d4a0b8d31f8cdc4a08/raw' \
| tee '$SUBL/Preferences.sublime-settings' >/dev/null"
curl -fsSL "$GIST/12793d5354d546d4a0b8d31f8cdc4a08/raw" \
	| tee "$SUBL/Preferences.sublime-settings" >/dev/null


# Importar configuración de Sublime Merge
SMERGE="$CONFIG/sublime-merge/Packages/User"
echo -e "\n${D}${O}Importar configuración de Sublime Merge${F}"
echo "mkdir -p '$SMERGE'"
mkdir -p "$SMERGE"
echo "curl -fsSL '$GIST/f415269ddcf22f3b06eaaf341aea9b49/raw' \
| tee '$SMERGE/Preferences.sublime-settings' >/dev/null"
curl -fsSL "$GIST/f415269ddcf22f3b06eaaf341aea9b49/raw" \
	| tee "$SMERGE/Preferences.sublime-settings" >/dev/null


# Importar configuración de VS Code
VSCODE="$CONFIG/Code/User"
echo -e "\n${D}${O}Importar configuración de VS Code${F}"
echo "mkdir -p '$VSCODE'"
mkdir -p "$VSCODE"
echo "curl -fsSL '$GIST/dcd9678504da9137d45e92fa16a76df1/raw' \
| tee '$VSCODE/settings.json' >/dev/null"
curl -fsSL "$GIST/dcd9678504da9137d45e92fa16a76df1/raw" \
	| tee "$VSCODE/settings.json" >/dev/null
echo "curl -fsSL '$GIST/ed2c2f10829db4f78b1473d6b990eeb7/raw' \
| tee '$VSCODE/keybindings.json' >/dev/null"
curl -fsSL "$GIST/ed2c2f10829db4f78b1473d6b990eeb7/raw" \
	| tee "$VSCODE/keybindings.json" >/dev/null


# Importar configuración de Terminator
TERM="$CONFIG/terminator"
echo -e "\n${D}${O}Importar configuración de Terminator${F}"
echo "mkdir -p '$TERM'"
mkdir -p "$TERM"
echo "curl -fsSL '$GIST/4eab7f25c2d334058e769952ca03f6af/raw' \
| tee '$TERM/config' >/dev/null"
curl -fsSL "$GIST/4eab7f25c2d334058e769952ca03f6af/raw" \
	| tee "$TERM/config" >/dev/null


## Instalar Oh My Zsh
echo -e "\n${D}${O}Instalar Oh My Zsh${F}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended

echo -e "\n${D}${O}Instalar plugins para OMZ${F}"
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"


# Instalar p10k
echo -e "\n${D}${O}Instalar p10k${F}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"


# Instalar NVM
echo -e "\n${D}${O}Instalar NVM${F}"
echo "curl -o- \"https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh\" | XDG_CONFIG_HOME=\"$CONFIG\" bash"
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh" | XDG_CONFIG_HOME="$CONFIG" bash


# Configurar Zsh
echo -e "\n${D}${O}Configurar Zsh${F}"
echo "curl -fsSL 'https://raw.githubusercontent.com/mdanieltg/zsh-profile/main/zshrc-omz-p10k' \
| tee '$HOME/.zshrc' >/dev/null"
curl -fsSL "https://raw.githubusercontent.com/mdanieltg/zsh-profile/main/zshrc-omz-p10k" \
	| tee "$HOME/.zshrc" >/dev/null


# Instalar Nodejs 14
echo -e "\n${D}${O}Instalar Node${F}"
echo "zsh -i -c \"nvm install 14\""
zsh -i -c "nvm install 14"
echo "zsh -i -c \"npm install -g npm yarn\""
zsh -i -c "npm install -g npm yarn"


echo -e "\n\033[0;33m--|${O} ¡Finalizado!\033[0;33m |--${F}\n"
