#!/bin/bash
# Installing Docker
sudo apt-get remove docker docker-engine docker.io
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -a -G docker $USER
sudo systemctl enable docker
sudo systemctl restart docker

# Set up NGINX staging
sudo mkdir /root/nginx-staging
cd /root/nginx-staging
sudo git clone --depth 1 https://github.com/LLACHICA/AzureWebServer.git
cd /root/nginx-staging/AzureWebServer
sudo curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo docker-compose up -d
