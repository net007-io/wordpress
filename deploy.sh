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
DOMAIN=$1
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
mkdir ~/docker/openresty/certs
cp default.example.conf ~/docker/openresty/config/default.conf
mkdir ~/docker/wordpress
mkdir ~/docker/mysql

# setup acme.sh
curl -sfSL https://get.acme.sh | sh
acme.sh --issue --dns dns_cf -d *.${DOMAIN} -d ${DOMAIN}
acme.sh  --installcert  -d *.${DOAMIN} --key-file ~/docker/openresty/certs/private.key --fullchain-file ~/docker/openresty/certs/fullchain.cer

# setup openresty & wordpress
echo "########## setup openresty & wordpress ##########"
cd ~/docker
docker network create --gateway 172.16.33.1 --subnet 172.16.33.0/24 services
cp docker-compose.example.yml ~/docker/docker-compose.yml
docker-compose up -d

