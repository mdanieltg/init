#!/bin/bash
if [ $# -ne 1 ]; then
	echo "Se necesita un argumento. El argumento puede ser ubuntu o fedora. Ej:"
	echo " \$ ./init.sh ubuntu"
	exit 1
elif [[ "$1" = "fedora" ]]; then
	SYS="fedora"
elif [[ "$1" == "ubuntu" ]]; then
	SYS="ubuntu"
else
	echo "Opción no válida."
	echo "Las opciones válidas son: ubuntu, fedora. Ej:"
	echo " \$ ./init.sh ubuntu"
	exit 2
fi

curl -fsSL "https://raw.githubusercontent.com/mdanieltg/init/main/$SYS-init.sh" \
	| sudo USR=${USER} bash -
