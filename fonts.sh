#!/bin/bash
FONTS=

D='\033[0;33m'
O='\033[0;34m'
F='\033[0m'

if [ $UID -eq 0 ]; then
	echo "Instalando fuentes a nivel global (sistema)."
	echo "Presione Ctrl+C para cancelar."
	sleep 7
	FONTS="/usr/share/fonts"
else
	echo "Instalando fuentes a nivel local (usuario)."
	echo "Presione Ctrl+C para cancelar."
	sleep 7
	FONTS="$HOME/.local/share/fonts"
fi
echo "Continuando con la instalación...\n"

echo -e "\n${D}-> ${O}Instalando fuentes${F}"

# MesloLGS NF
MLN="$FONTS/meslolgs-nf"
mkdir -p "$MLN"
wget -O "$MLN/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
wget -O "$MLN/MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
wget -O "$MLN/MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
wget -O "$MLN/MesloLGS NF Bold Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"

# Hack
wget -O /tmp/hack.tar.xz 'https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.tar.xz'
tar -xvf /tmp/hack.tar.xz -C "$FONTS/hack"
rm /tmp/hack.tar.xz

# JetBrains Mono
wget -O /tmp/jb.zip 'https://download.jetbrains.com/fonts/JetBrainsMono-2.225.zip'

unzip -d jb /tmp/jb.zip
mv jb/fonts/ttf "$FONTS/jetbrains-mono"
rm /tmp/jb.zip


echo -e "\n${D}--|${O} ¡Finalizado!${D} |--${F}\n"
