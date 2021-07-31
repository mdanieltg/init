#!/bin/bash
# D: Distribución objetivo
# T: Tipografías
# P: Preferencias de usuario

if [ $UID -eq 0 ]; then
	echo -e "\033[0;31m¡No ejecutar con privilegios elevados o como root!\033[0m"
	exit 1
fi

# Leer argumentos de entrada
for arg in "$@"; do
	if [[ "$arg" == "-h" ]]; then
		echo "init.sh"
		echo "Instala el software base, así como tipografías y preferencias de usuario en una instalación 'fresca' de Ubuntu, Fedora o derivados."
		echo -e "\nSintaxis:"
		echo -e " ./init.sh [-t|-T] [-p] [-d=distro]\n"
		echo "Opciones:"
		echo " -t | -T      Instalar tipografías localmente (t) o globalmente (T)."
		echo " -p           Configurar las preferencias de usuario."
		echo " -d=distro    Distribución a configurar. Posibles valores: ubuntu y fedora"
		echo -e "\nSe debe elegir al menos una opción de las tres posibles, y se pueden combinar entre sí.\n"
		echo "Sitio web: https://github.com/mdanieltg/init"
		exit 0;
	elif [[ "$arg" == "-t" ]]; then
		T="local"
	elif [[ "$arg" == "-T" ]]; then
		T="global"
	elif [[ "$arg" == "-p" ]]; then
		P=true
	elif [[ "$arg" == "-d=ubuntu" ]]; then
		D="ubuntu"
	elif [[ "$arg" == "-d=fedora" ]]; then
		D="fedora"
	else
		echo "Error: no se reconoce el argumento '$arg'"
		echo "Ejecutar ./init.sh -h para visualizar las opciones válidas."
		exit 2;
	fi
done

if [ -z $D ] && [ -z $P ] && [ -z $T ]; then
	echo "Error: se debe pasar al menos un argumento."
	echo "Ejecutar ./init.sh -h para visualizar las opciones válidas."
	exit 3
fi

GH="https://raw.githubusercontent.com/mdanieltg/init/main"

# Tipografías
if [ ! -z $T ]; then
	if [[ "$T" == "global" ]]; then
		sudo -v
		wget -nv -O - "$GH/fonts.sh" | sudo bash -
	else
		wget -nv -O - "$GH/fonts.sh" | bash -
	fi
fi

# Distribución - software base
if [ ! -z $D ]; then
	sudo -v
	wget -nv -O - "$GH/$D-init.sh" | sudo USR=${USER} bash -
fi

# Preferencias de usuario
if [ ! -z $P ]; then
	wget -nv -O - "$GH/preferences.sh" | bash -
fi
