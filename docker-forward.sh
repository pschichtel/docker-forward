#!/usr/bin/env bash
# Docker Forward

set -euo pipefail

version="1"

metadata() {
    local socat
    socat="$(which socat 2>/dev/null || echo "")"
    local socat_notice=""
    if [ -z "$socat" ]
    then
        socat_notice=" (socat currently missing!)"
    fi
    cat <<CUT
{
    "SchemaVersion": "0.1.0",
    "Vendor": "Phillip Schichtel",
    "Version": "v${version}",
    "ShortDescription": "Docker Port Forward${socat_notice}",
    "URL": "https://github.com/pschichtel/docker-forward"
}
CUT
}

usage() {
    cat <<EOF
Usage: docker forward <local address> <local port> <remote address> <remote port> [remote docker network]
EOF
}

if [ "${1:-}" == "docker-cli-plugin-metadata" ]
then
    metadata
    exit 0
fi

shift
if [ "$#" = 0 ]
then
    usage
    exit 0
fi

if [ "$1" == "-h" ] || [ "$1" == "--help" ]
then
    usage
    exit 0
fi

if [ "$#" -lt 4 ]
then
    echo "Missing argument!"
    usage
    exit 1
fi

local_addr="${1?no local address}"
local_port="${2?no local port}"
target_host="${3?no target host}"
target_port="${4?no target port}"
target_network="${5:-}"
proxy_container_image="${PROXY_IMAGE:-"pschichtel/deployment-helper:1-alpine"}"

if [ -n "$target_network" ]
then
    target_network="--net='${target_network}'"
fi

docker_command="${DOCKER_CLI_PLUGIN_ORIGINAL_CLI_COMMAND:-"docker"}"

command="'$docker_command' run --rm -i ${target_network} '$proxy_container_image' socat - 'TCP-CONNECT:${target_host}:${target_port}'"
socat -d -d -ls "TCP-LISTEN:${local_port},bind=${local_addr},fork,reuseaddr" "EXEC:${command}"