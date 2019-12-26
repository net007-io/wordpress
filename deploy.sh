#!/usr/bin/env bash
set -e

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 
	exit 1
fi

# functions
function get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/'
}

# constants
DOCKER_COMPOSE_LATEST_VERSION=`get_latest_release docker/compose`
DOCKER_COMPOSE_DOWNLOAD_URL="https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_LATEST_VERSION}/docker-compose-Linux-x86_64"

# install docker & docker-compose
echo "########## install docker & docker-compose ##########"
curl https://get.docker.com | bash
curl -sfSL --retry 3 ${DOCKER_COMPOSE_DOWNLOAD_URL} -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

mkdir ~/docker
mkdir ~/docker/openresty
mkdir ~/docker/openresty/config
cp default.example.conf ~/docker/openresty/config/default.conf
mkdir ~/docker/wordpress
mkdir ~/docker/mysql

# setup openresty & wordpress
echo "########## setup openresty & wordpress ##########"
cd ~/docker
docker network create --gateway 172.16.33.1 --subnet 172.16.33.0/24 services
cp docker-compose.example.conf docker-compose.conf
docker-compose up -d

# setup acme.sh
curl -sfSL https://get.acme.sh | sh
