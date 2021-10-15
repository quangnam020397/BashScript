#!/bin/bash

#remove dokcer old version
sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine

# remove old file 
sudo rm -rf /var/lib/docker/

sudo yum install -y yum-utils

# Set up the repository
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker Engine
sudo yum install docker-ce docker-ce-cli containerd.io --allowerasing

# Start Docker.
sudo systemctl start docker

docker version
