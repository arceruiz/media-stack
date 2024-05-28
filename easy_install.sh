#!/bin/bash


source /usr/local/src/balthazarr/envinstall_log.sh


install_docker() {
    warn "Checking docker installation..."
    if ! [ -x "$(command -v docker)" ]; then
        warn "Starting docker installation"
        # Add Docker's official GPG key:
        sudo apt-get update -y
        sudo apt-get install ca-certificates curl -y
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc
        # Add the repository to Apt sources:
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
          $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        warn "Docker installation finished"
        sudo usermod -a -G docker $USER && warn "Logout is needed for Docker to work properly"
    fi
}

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'

NC='\033[00m'

log() {
    script_shell="$(readlink /proc/$$/exe | sed "s/.*\///")"
    if [ "${script_shell}" = "bash" ]; then
        echo -e "$1$2${NC}"
    else
        echo "$1$2${NC}"
    fi
}

warn() {
    log $YELLOW "$1"
}

start() {
    log $GREEN "$1"
}

finish() {
    SELECTED_COLOR="$RED"
    if [ "$2" -eq "0" ]; then
        SELECTED_COLOR="$GREEN"
    fi

    log $SELECTED_COLOR "$1"
    echo ""
}

install_docker

export $(cat .env | xargs)

docker compose up -d 

