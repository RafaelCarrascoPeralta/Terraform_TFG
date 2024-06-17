#!/bin/bash

echo "INSTALACION DE MICROK8S"
sudo apt update -y
sudo apt install curl -y
sudo apt install git -y
sudo apt install snapd -y 
sudo snap install microk8s --classic
export PATH=$PATH:/snap/bin
sudo usermod -a -G microk8s $USER
newgrp microk8s <<EOF
export PATH=$PATH:/snap/bin
microk8s start
microk8s status --wait-ready
microk8s enable dashboard
microk8s enable dns
microk8s enable registry
microk8s enable istio
microk8s enable ingress
microk8s enable cert-manager
microk8s enable kube-hunter
microk8s enable kube-bench

echo "Clonando repositorio de GitHub..."
git clone https://github.com/RafaelCarrascoPeralta/TFG_yaml.git

echo "Instalación y configuración completa."
