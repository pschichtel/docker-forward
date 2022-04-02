Docker Forward Plugin
=====================

This Docker CLI Plugin allows you to forward a local port to a remote port in a docker container.

Installation
------------

### Manual Installation

1. Make sure `socat` is installed on your machine and in the path
2. `mkdir -p "$HOME/.docker/cli-plugins"`
3. `curl -L -o "HOME/.docker/cli-plugins/docker-forward" 'https://raw.githubusercontent.com/pschichtel/docker-forward/main/docker-forward.sh'`

### Distro Packages

* [Archlinux AUR](https://aur.archlinux.org/)
* ???