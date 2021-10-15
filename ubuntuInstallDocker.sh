#!/bin/bash

#remove dokcer old version
sudo apt-get remove docker docker-engine docker.io containerd runc

# remove old file 
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# Set up the repository
sudo apt-get update

sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Install Docker Engine
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker.io

# Start Docker.
sudo systemctl start docker

docker version

read -p "install docker-compose:.....[y/n]"

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

docker-compose --version