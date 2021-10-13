#!/bin/bash
## Colores (https://gist.github.com/mdanieltg/431aa8cde142ccb0d28b1f3ec21c51e3)
CR='\033[0;31m'
CY='\033[0;33m'
CB='\033[0;34m'
CRESET='\033[0m'


print_start() {
	echo -e "\n$CY--|$CB $1 $CY|--$CRESET"
}

print_end() {
	echo -e "\n$CY--|$CB ¡Finalizado! $CY|--$CRESET"
}

print_activity() {
	echo -e "\n$CY>>>$CB $1$CRESET"
}

print_error() {
	echo -e "$CR$1\nEjecutar ./init.sh -h para visualizar las opciones válidas.$CRESET"
}

print_help() {
	echo "init.sh
Instala el software base, así como tipografías y preferencias de usuario en una instalación 'fresca' de Ubuntu, Fedora o derivados.

Sintaxis:
 sudo U=\$USER ./init.sh [-t|-T] [-p] [-d=distro]
 sudo U=\$USER bash init.sh [-t|-T] [-p] [-d=distro]

Opciones:
 -t | -T      Instalar tipografías localmente (t) o globalmente (T).
 -p           Configurar las preferencias de usuario.
 -d=distro    Distribución a configurar. Posibles valores: ubuntu y fedora

Se debe elegir al menos una opción de las tres posibles, y se pueden combinar entre sí.

Sitio web: https://github.com/mdanieltg/init"
}

fonts() {
	local FONTS
	local MSG
	local US

	if [[ "$1" == "global" ]]; then
		US=root
		FONTS="/usr/share/fonts"
		MSG="global (sistema)"
	else
		US=$U
		FONTS="$(eval echo ~$U)/.local/share/fonts"
		MSG="local (usuario)"
	fi

	print_start "Instalando tipografías a nivel $MSG"

	# MesloLGS NF
	print_activity "MesloLGS NF"
	local REMOTE="https://github.com/romkatv/powerlevel10k-media/raw/master"
	local MLN="$FONTS/meslolgs-nf"
	sudo -u $US mkdir -p "$MLN"
	sudo -u $US wget -qO "$MLN/MesloLGS NF Regular.ttf" "$REMOTE/MesloLGS%20NF%20Regular.ttf"
	sudo -u $US wget -qO "$MLN/MesloLGS NF Bold.ttf" "$REMOTE/MesloLGS%20NF%20Bold.ttf"
	sudo -u $US wget -qO "$MLN/MesloLGS NF Italic.ttf" "$REMOTE/MesloLGS%20NF%20Italic.ttf"
	sudo -u $US wget -qO "$MLN/MesloLGS NF Bold Italic.ttf" "$REMOTE/MesloLGS%20NF%20Bold%20Italic.ttf"

	# Hack
	print_activity "Hack"
	wget -qO /tmp/hack.tar.xz https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.tar.xz
	sudo -u $US mkdir -p "$FONTS/hack"
	sudo -u $US tar -xf /tmp/hack.tar.xz -C "$FONTS/hack"
	rm /tmp/hack.tar.xz

	# JetBrains Mono
	print_activity "JetBrains Mono"
	wget -qO /tmp/jb.zip https://download.jetbrains.com/fonts/JetBrainsMono-2.225.zip
	sudo -u $US unzip -qj /tmp/jb.zip "fonts/ttf/*" -d "$FONTS/jetbrains-mono"
	rm -r /tmp/jb.zip

	print_end
}

preferences() {
	local HOME=$(eval echo ~$U)
	local CONFIG="$HOME/.config"
	local LIB="$HOME/.local/lib"
	local BIN="$HOME/.local/bin"
	local ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
	local GH="https://github.com/mdanieltg"

	print_start "Configuraciones personales"


	# Crear directorios locales
	sudo -u $U mkdir -p "$LIB" "$BIN"


	# Instalar Firefox Developer Edition
	print_activity "Instalar Firefox Developer Edition"
	wget -qO /tmp/firefox.tar.bz2 \
		"https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=es-MX"
	sudo -u $U tar -xf /tmp/firefox.tar.bz2 -C "$LIB"
	sudo -u $U ln -sf "$LIB/firefox/firefox" "$BIN/firefox-developer-edition"
	rm /tmp/firefox.tar.bz2


	# Importar configuración de Git
	print_activity "Importar configuración de Git"
	curl -fsSL "$GH/config/raw/main/gitconfig" | sudo -u $U tee "$HOME/.gitconfig" >/dev/null


	# Importar configuración de Vim
	print_activity "Importar configuración de Vim"
	sudo -u $U git clone -q $GH/vim-profile.git "$HOME/.vim"
	sudo -u $U ln -sf "$HOME/.vim/vimrc" "$HOME/.vimrc"


	# Importar configuración de Sublime Text
	print_activity "Importar configuración de Sublime Text"
	local SUBL="$CONFIG/sublime-text/Packages/User"
	sudo -u $U mkdir -p "$SUBL"
	curl -fsSL "$GH/config/raw/main/sublime-settings.json" \
		| sudo -u $U tee "$SUBL/Preferences.sublime-settings" >/dev/null
	curl -fsSL "$GH/config/raw/main/sublime-keybindings.json" \
		| sudo -u $U tee "$SUBL/Default (Linux).sublime-keymap" >/dev/null
	curl -fsSL "$GH/config/raw/main/CSS3-sublime-settings.json" \
		| sudo -u $U tee "$SUBL/CSS3.sublime-settings" >/dev/null


	# Importar configuración de Sublime Merge
	print_activity "Importar configuración de Sublime Merge"
	local SMERGE="$CONFIG/sublime-merge/Packages/User"
	sudo -u $U mkdir -p "$SMERGE"
	curl -fsSL "$GH/config/raw/main/sublimemerge-settings.json" \
		| sudo -u $U tee "$SMERGE/Preferences.sublime-settings" >/dev/null


	# Importar configuración de VS Code
	print_activity "Importar configuración de VS Code"
	local VSCODE="$CONFIG/Code/User"
	sudo -u $U mkdir -p "$VSCODE"
	curl -fsSL "$GH/config/raw/main/vscode-settings.json" \
		| sudo -u $U tee "$VSCODE/settings.json" >/dev/null
	curl -fsSL "$GH/config/raw/main/vscode-keybindings.json" \
		| sudo -u $U tee "$VSCODE/keybindings.json" >/dev/null


	# Importar configuración de Terminator
	print_activity "Importar configuración de Terminator"
	local TERM="$CONFIG/terminator"
	sudo -u $U mkdir -p "$TERM"
	curl -fsSL "$GH/config/raw/main/terminator-config" \
		| sudo -u $U tee "$TERM/config" >/dev/null


	## Instalar Oh My Zsh
	print_activity "Instalar Oh My Zsh"
	sudo -u $U sh -c "$(wget -qO- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended

	print_activity "Instalar plugins para OMZ"
	sudo -u $U git clone -q https://github.com/zsh-users/zsh-autosuggestions.git \
		"$ZSH_CUSTOM/plugins/zsh-autosuggestions"
	sudo -u $U git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git \
		"$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"


	# Instalar p10k
	print_activity "Instalar p10k"
	sudo -u $U git clone -q --depth=1 https://github.com/romkatv/powerlevel10k.git \
		"$ZSH_CUSTOM/themes/powerlevel10k"


	# Instalar NVM
	print_activity "Instalar NVM"
	curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh" \
		| sudo -u $U XDG_CONFIG_HOME="$CONFIG" bash


	# Configurar Zsh
	print_activity "Configurar Zsh"
	curl -fsSL "$GH/zsh-profile/raw/main/zshrc-omz-p10k" \
		| sudo -u $U tee "$HOME/.zshrc" >/dev/null


	# Instalar Nodejs 14
	print_activity "Instalar Node"
	sudo -u $U zsh -i -c "nvm install stable"
	sudo -u $U zsh -i -c "nvm alias default stable"
	sudo -u $U zsh -i -c "npm install -g npm@latest yarn"


	print_end
}

fedora_install() {
	print_start "Instalación base de Fedora"

	# Instalar software base
	print_activity "Instalar software base"
	dnf -q install -y curl dnf-plugins-core

	# Obtener llaves
	print_activity "Obtener llaves PGP"
	rpm --quiet --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
	rpm --quiet --import https://packages.microsoft.com/keys/microsoft.asc
	rpm --quiet --import https://downloads.1password.com/linux/keys/1password.asc

	# Agregar repositorios
	print_activity "Agregar repositorios"
	dnf -q config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
	dnf -q config-manager --add-repo https://github.com/mdanieltg/init/raw/main/fedora-repos/1password.repo
	dnf -q config-manager --add-repo https://github.com/mdanieltg/init/raw/main/fedora-repos/code.repo
	dnf -q config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
	dnf -q config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo

	# Instalar software restante
	print_activity "Instalar software restante"
	dnf -q install -y util-linux-user git-core zsh vim gh terminator firefox thunderbird dotnet-sdk-3.1 dotnet-sdk-5.0 sublime-text sublime-merge code 1password docker-ce docker-ce-cli

	# Habilitar servicio de Docker
	print_activity "Habilitar servicio de Docker"
	systemctl enable docker.service
	systemctl enable containerd.service

	# Actualizar sistema
	print_activity "Actualizar paquetes"
	dnf -q update -y

	# Habilitar Flatpak
	print_activity "Habilitar Flatpak"
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

	# Instalar aplicaciones de Flatpak
	print_activity "Instalar aplicaciones de Flatpak"
	sudo -u $U flatpak install --user --noninteractive -y flathub com.getpostman.Postman io.typora.Typora org.telegram.desktop com.spotify.Client

	# Cambiar shell a Zsh
	print_activity "Cambiar shell a Zsh"
	chsh -s $(which zsh) $U

	# Agregar usuario al grupo de Docker
	print_activity "Agregar usuario al grupo de Docker"
	usermod -aG docker $U

	print_end
}

ubuntu_install() {
	print_start "Instalación base de Ubuntu"

	# Detener el servicio de actualizaciones no supervisadas, ya que puede obstruir la instalación de los paquetes
	print_activity "Deshabilitar las actualizaciones no supervisadas"
	systemctl disable --now unattended-upgrades.service
	apt-get -qy remove unattended-upgrades

	# Refrescar la caché de paquetes
	print_activity "Actualizar la caché de paquetes"
	apt-get -q update

	# Instalar utilidades
	print_activity "Instalar utilidades"
	apt-get -qy install curl apt-transport-https

	# Obtener llaves
	print_activity "Obtener llaves PGP"
	curl -sS "https://download.sublimetext.com/sublimehq-pub.gpg" | apt-key add -
	curl -sS "https://downloads.1password.com/linux/keys/1password.asc" | apt-key add -
	curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" | apt-key add -
	curl -fsSL "https://cli.github.com/packages/githubcli-archive-keyring.gpg" \
		| gpg -q --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg

	# Agregar fuentes a /etc/apt/sources.list.d
	SRC="/etc/apt/sources.list.d"
	print_activity "Agregar fuentes a /etc/apt/sources.list.d"
	echo "deb https://download.sublimetext.com/ apt/stable/" \
		| tee $SRC/sublime-text.list >/dev/null
	echo "deb [arch=amd64] https://downloads.1password.com/linux/debian/amd64 stable main" \
		| tee $SRC/1password.list >/dev/null
	echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
		| tee $SRC/docker.list >/dev/null
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
		| sudo tee $SRC/github-cli.list >/dev/null

	# Instalar el repositorio de .NET
	print_activity "Instalar el repositorio de .NET"
	wget -q "https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb"
	dpkg -i packages-microsoft-prod.deb
	rm packages-microsoft-prod.deb

	# Refrescar la caché de paquetes
	print_activity "Actualizar la caché de paquetes nuevamente"
	apt-get update

	# Instalar software restante
	print_activity "Instalar software restante"
	apt-get -qy install git zsh vim build-essential gh terminator firefox firefox-locale-es thunderbird thunderbird-locale-es snap dotnet-sdk-3.1 dotnet-sdk-5.0 sublime-text sublime-merge 1password docker-ce docker-ce-cli

	# Habilitar servicio de Docker
	print_activity "Habilitar servicio de Docker"
	systemctl enable docker.service
	systemctl enable containerd.service

	# Instalar Snaps
	print_activity "Instalar Snaps"
	snap install postman typora telegram-desktop spotify

	# Instalar VS Code
	print_activity "Instalar VS Code"
	wget -qO vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
	dpkg -i vscode.deb
	rm vscode.deb

	# Arreglar dependencias incumplidas
	print_activity "Arreglar dependencias incumplidas (si existen)"
	apt-get -qyf install

	# Actualizar sistema
	print_activity "Actualizar paquetes"
	apt-get -qy upgrade

	# Limpiar
	print_activity "Limpiar"
	apt-get -qy autoremove --purge
	apt-get -qy clean

	# Actualizar alternativas
	print_activity "Actualizar alternativas"
	update-alternatives --set editor $(which vim.basic)
	update-alternatives --set x-terminal-emulator $(which terminator)

	# Cambiar shell a Zsh
	print_activity "Cambiar shell a Zsh"
	chsh -s $(which zsh) $U

	# Agregar usuario al grupo de Docker
	print_activity "Agregar usuario al grupo de Docker"
	usermod -aG docker $U

	print_end
}


## Leer argumentos de entrada
for arg in "$@"; do
	if [[ "$arg" == "-h" ]]; then
		print_help
		exit 0;
	elif [[ "$arg" == "-t" ]]; then
		TIPO="local"
	elif [[ "$arg" == "-T" ]]; then
		TIPO="global"
	elif [[ "$arg" == "-p" ]]; then
		PREF=true
	elif [[ "$arg" == "-d=ubuntu" ]]; then
		DIST="ubuntu"
	elif [[ "$arg" == "-d=fedora" ]]; then
		DIST="fedora"
	else
		print_error "No se reconoce el argumento '$arg'.\n"
		exit 2;
	fi
done


## Validaciones
if [ $EUID -ne 0 ]; then
	ERR="Se debe ejecutar con privilegios elevados\n"
fi
if [ -z "$U" ]; then
	ERR="${ERR}Se debe proporcionar la variable de entorno \$U, indicando el nombre del usuario que invoca el script.\n"
fi
if [ -z "$DIST" ] && [ -z "$PREF" ] && [ -z "$TIPO" ]; then
	ERR="${ERR}Se debe pasar al menos un argumento.\n"
fi
if [ -n "$ERR" ]; then
	print_error "$ERR"
	exit 1
fi


## Tareas
if [ -n "$DIST" ]; then
	if [[ "$DIST" == "ubuntu" ]]; then
		ubuntu_install
	else
		fedora_install
	fi
fi

if [ -n "$PREF" ]; then
	preferences
fi

if [ -n "$TIPO" ]; then
	fonts $TIPO
fi
