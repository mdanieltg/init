#!/bin/bash -x
CONFIG="$HOME/.config"
LIB="$HOME/.local/lib"
BIN="$HOME/.local/bin"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
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
mkdir -p "$LIB" "$BIN"


# Instalar Firefox Developer Edition
echo -e "\n${D}${O}Instalar Firefox Developer Edition${F}"
wget -nv -O /tmp/firefox.tar.bz2 \
	"https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=es-MX"
tar -xf /tmp/firefox.tar.bz2 -C "$LIB"
ln -sf "$LIB/firefox/firefox" "$BIN/firefox-developer-edition"
rm /tmp/firefox.tar.bz2


# Importar configuración de Git
echo -e "\n${D}${O}Importar configuración de Git${F}"
curl -fsSL "$GH/config/raw/main/gitconfig" | tee "$HOME/.gitconfig" >/dev/null


# Importar configuración de Vim
echo -e "\n${D}${O}Importar configuración de Vim${F}"
git clone -q $GH/vim-profile.git "$HOME/.vim"
ln -sf "$HOME/.vim/vimrc" "$HOME/.vimrc"


# Importar configuración de Sublime Text
SUBL="$CONFIG/sublime-text/Packages/User"
echo -e "\n${D}${O}Importar configuración de Sublime Text${F}"
mkdir -p "$SUBL"
curl -fsSL "$GH/config/raw/main/sublime-settings.json" \
	| tee "$SUBL/Preferences.sublime-settings" >/dev/null


# Importar configuración de Sublime Merge
SMERGE="$CONFIG/sublime-merge/Packages/User"
echo -e "\n${D}${O}Importar configuración de Sublime Merge${F}"
mkdir -p "$SMERGE"
curl -fsSL "$GH/config/raw/main/sublimemerge-settings.json" \
	| tee "$SMERGE/Preferences.sublime-settings" >/dev/null


# Importar configuración de VS Code
VSCODE="$CONFIG/Code/User"
echo -e "\n${D}${O}Importar configuración de VS Code${F}"
mkdir -p "$VSCODE"
curl -fsSL "$GH/config/raw/main/vscode-settings.json" \
	| tee "$VSCODE/settings.json" >/dev/null
curl -fsSL "$GH/config/raw/main/vscode-keybindings.json" \
	| tee "$VSCODE/keybindings.json" >/dev/null


# Importar configuración de Terminator
TERM="$CONFIG/terminator"
echo -e "\n${D}${O}Importar configuración de Terminator${F}"
mkdir -p "$TERM"
curl -fsSL "$GH/config/raw/main/terminator-config" \
	| tee "$TERM/config" >/dev/null


## Instalar Oh My Zsh
echo -e "\n${D}${O}Instalar Oh My Zsh${F}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended

echo -e "\n${D}${O}Instalar plugins para OMZ${F}"
git clone -q https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"


# Instalar p10k
echo -e "\n${D}${O}Instalar p10k${F}"
git clone -q --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"


# Instalar NVM
echo -e "\n${D}${O}Instalar NVM${F}"
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh" | XDG_CONFIG_HOME="$CONFIG" bash


# Configurar Zsh
echo -e "\n${D}${O}Configurar Zsh${F}"
curl -fsSL "$GH/zsh-profile/raw/main/zshrc-omz-p10k" \
	| tee "$HOME/.zshrc" >/dev/null


# Instalar Nodejs 14
echo -e "\n${D}${O}Instalar Node${F}"
zsh -i -c "nvm install 14"
zsh -i -c "npm install -g npm yarn"


echo -e "\n\033[0;33m--|${O} ¡Finalizado!\033[0;33m |--${F}\n"
