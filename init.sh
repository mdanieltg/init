#!/bin/bash
# S: Sistema operativo
# T: Tipografías globales o locales
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
		echo -e " ./init.sh [-t|-T] [-p] <ubuntu|fedora>\n"
		echo "Opciones:"
		echo " -t | -T      Instalar fuentes localmente (t), globalmente (T) o no instalar."
		echo " -p           Configurar las preferencias de usuario."
		echo -e "\nSitio web: https://github.com/mdanieltg/init"
		exit 0;
	elif [[ "$arg" == "-t" ]]; then
		T="local"
	elif [[ "$arg" == "-T" ]]; then
		T="global"
	elif [[ "$arg" == "-p" ]]; then
		P=true
	elif [[ "$arg" == "ubuntu" ]]; then
		S="ubuntu"
	elif [[ "$arg" == "fedora" ]]; then
		S="fedora"
	else
		echo "Error: no se reconoce el argumento '$arg'"
		echo "Ejecutar ./init.sh -h para visualizar las opciones válidas."
		exit 2;
	fi
done


if [ -z $S ]; then
	echo "Opción inválida."
	echo "Las opciones válidas son ubuntu o fedora. Ej:"
	echo " \$ ./init.sh ubuntu"
	exit 3
else
	sudo -v

	# Sistema operativo
	wget -O - "https://raw.githubusercontent.com/mdanieltg/init/main/$S-init.sh" \
		| sudo USR=${USER} bash -

	# Preferencias de usuario
	if [ ! -z $P ]; then
		wget -O - "https://raw.githubusercontent.com/mdanieltg/init/main/preferences.sh" | bash -
	fi

	# Fuentes
	if [ ! -z $T ]; then
		if [[ "$T" == "global" ]]; then
			sudo -v
			wget -O - "https://raw.githubusercontent.com/mdanieltg/init/main/fonts.sh" | sudo bash -
		else
			wget -O - "https://raw.githubusercontent.com/mdanieltg/init/main/fonts.sh" | bash -
		fi
	fi
fi
