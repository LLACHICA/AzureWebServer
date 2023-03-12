#!/bin/bash
#Installing Docker
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"
sudo apt-get update
sudo apt-get install docker-ce nginx mariadb-client -y
sudo usermod -a -G docker $USER
sudo systemctl enable docker
sudo systemctl restart docker
sudo mkdir /root/nginx-staging
cd /root/nginx-staging
sudo git clone https://github.com/LLACHICA/AzureWebServer.git
cd AzureWebServer
sudo cp -rp ./html/* /usr/share/nginx/html
sudo cp ./scripts/my-web.conf /etc/nginx/conf.d/
sudo cp ./scripts/sql_create.sh /root/ && chmod 755 /root/sql_create.sh
cd /root/nginx-staging/AzureWebServer
IP_ADDRESS=$(hostname -i)
docker build --build-arg IP_ADDRESS=$IP_ADDRESS -t my-nginx-website .
sudo systemctl stop nginx
sudo docker run --name docker-nginx -p 80:80 my-nginx-website
sudo . /root/sql_create.sh > output.txt 2>&1

