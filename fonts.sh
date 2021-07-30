#!/bin/bash
FONTS="$HOME/.local/share/fonts"

D='\033[0;33m'
O='\033[0;34m'
F='\033[0m'

if [ $UID -eq 0 ]; then
	FONTS="/usr/share/fonts"
	MSG="global (sistema)"
else
	MSG="local (usuario)"
fi

echo -e "\n\033[0;33m--|${O} Instalando fuentes a nivel $MSG ${F}\033[0;33m|--"


# MesloLGS NF
echo -e "\n${D}-> ${O}MesloLGS NF${F}"
MLN="$FONTS/meslolgs-nf"
mkdir -p "$MLN"
wget -nv -O "$MLN/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
wget -nv -O "$MLN/MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
wget -nv -O "$MLN/MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
wget -nv -O "$MLN/MesloLGS NF Bold Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"

# Hack
echo -e "\n${D}-> ${O}Hack${F}"
wget -nv -O /tmp/hack.tar.xz 'https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.tar.xz'
mkdir -p "$FONTS/hack"
tar -xf /tmp/hack.tar.xz -C "$FONTS/hack"
rm /tmp/hack.tar.xz

# JetBrains Mono
echo -e "\n${D}-> ${O}JetBrains Mono${F}"
wget -nv -O /tmp/jb.zip 'https://download.jetbrains.com/fonts/JetBrainsMono-2.225.zip'
unzip -q /tmp/jb.zip -d /tmp/jb
mv /tmp/jb/fonts/ttf "$FONTS/jetbrains-mono"
rm -r /tmp/jb.zip /tmp/jb
