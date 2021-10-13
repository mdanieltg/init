# Init

Script de Bash para configurar una instalación nueva de [Ubuntu](https://ubuntu.com/download/desktop), [Fedora](https://getfedora.org/es/workstation/download/), o cualquier sistema derivado que utilice APT o DNF como administrador de paquetes.

## Utilización

Ejecutar el script `init.sh`:
```bash
./init.sh -p -T -d=ubuntu
```

Para consultar las opciones disponibles:
```bash
./init.sh -h
```

## Cambios al sistema

### Instalación de software:

- Software provisto por repositorios del sistema: Git, Zsh, VIM, cURL, Terminator, Firefox y Thunderbird.
- Software provisto por terceros:
  - [.NET SDK](https://dotnet.microsoft.com).
  - [Sublime Text](https://www.sublimetext.com) - A sophisticated text editor for code, markup and prose.
  - [Sublime Merge](https://www.sublimemerge.com) - Git Client, done Sublime.
  - [VS Code](https://code.visualstudio.com) - Code editing. Redefined.
  - [GitHub CLI](https://cli.github.com/) - Take GitHub to the command line.
  - [Docker](https://www.docker.com/get-started) - Containers.
  - [1Password](https://1password.com/) - Password manager.
- Software provisto por Snap o Flatpak: Postman, Chromium, Typora, Telegram Desktop y Spotify.

### Configuración personal:

- Cambiar la shell a Zsh.
- Importar mi configuración Git.
- Importar mi configuración VIM.
- Instalar [Oh My Zsh](https://ohmyz.sh).
- Instalar el tema [Powerlevel10k](https://github.com/romkatv/powerlevel10k#powerlevel10k).
- Instalar [NVM](https://github.com/nvm-sh/nvm).
  - Instalar [Node.js](https://nodejs.org/) versión 14 (LTS).
  - Instalar [Yarn](https://yarnpkg.com/).
- Agregar el usuario $U al grupo `docker`.
- Instalar Firefox Developer Edition.

## Renuncia de reponsabilidad

Este script fue creado con fines personales y no ha sido extensamente probado, por lo que su uso supone un riesgo inherente.

**USAR BAJO SU PROPIO RIESGO**
