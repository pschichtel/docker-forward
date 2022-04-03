Docker Forward Plugin
=====================

This Docker CLI Plugin allows you to forward a local port to a remote port in a docker container.

Usage
-----

```bash
docker forward <local bind ip> <local bind port> <remote target host> <remote target port> [optional docker network name]
```

Example:

```bash
docker forward 127.0.0.1 5005 some-service 5005
```

How It Works
------------

It starts socat in tcp-listen mode locally and runs a container for each connection to the local port. The container also runs socat and connects to the target host:port. The local socat and the container socat are connected through stdin and stdout of the container and the `docker run` command.

For this reason all connections take a short moment to establish since docker takes a short moment to actually start the container.

The container image can by anything as long as it has a `socat` binary in its path. By default it is [pschichtel/deployment-helper:1-alpine](https://hub.docker.com/r/pschichtel/deployment-helper) ([on GitHub](https://github.com/pschichtel/deployment-helper-docker)). By setting the `PROXY_IMAGE` environment variable any other image can be configured.

The `DOCKER_HOST` environment variable is also respected and so the tunnel also works with remote docker daemons.

If the target host is a docker service with more than one replica, then keep in mind that the tunnel is not connected to an individual container's port, but to a load-balanced service port. Each connection is likely to end up at a different container. Use container-specific hostnames or IP addresses to connect to a specific instance instead.

Installation
------------

### Manual Installation

1. Make sure all dependencies are installed: `bash`, `socat`, `docker-cli`
2. `mkdir -p "$HOME/.docker/cli-plugins"`
3. `curl -L -o "HOME/.docker/cli-plugins/docker-forward" 'https://raw.githubusercontent.com/pschichtel/docker-forward/main/docker-forward.sh'`

### Distro Packages

* [Archlinux AUR](https://aur.archlinux.org/packages/docker-forward)
* ???

See Also
--------

This plugin has been inspired by this project: https://github.com/iammathew/docker-port-forward.
