#!/bin/bash

# INSTALACION DE DOCKER

# INSTALACION DOCKER
echo "INSTALACION DE DOCKER"
sudo apt update -y
sudo apt install curl -y

sudo apt install software-properties-common apt-transport-https ca-certificates curl gnupg lsb-release -y
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo systemctl enable docker
sudo usermod -aG docker $USER
newgrp docker

