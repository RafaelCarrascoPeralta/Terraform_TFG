#!/bin/bash

echo "INSTALACION DE MICROK8S"

# Actualizar repositorios
echo "Actualizando repositorios..."
sudo apt update -y

# Instalar curl
echo "Instalando curl..."
sudo apt install curl -y

# Instalar git
echo "Instalando git..."
sudo apt install git -y

# Instalar snapd
echo "Instalando snapd..."
sudo apt install snapd -y 

# Instalar MicroK8s
echo "Instalando MicroK8s..." 
sudo snap install microk8s --classic

# Configurar PATH
echo "Configurando PATH..."
export PATH=$PATH:/snap/bin

# Añadir usuario al grupo de MicroK8s
echo "Añadiendo usuario al grupo de MicroK8s..."
sudo usermod -a -G microk8s $USER

# Crear nuevo grupo
echo "Creando nuevo grupo..."
newgrp microk8s <<EOF

# Configurar PATH nuevamente (por si acaso)
echo "Configurando PATH nuevamente..."
export PATH=$PATH:/snap/bin

# Iniciar MicroK8s
echo "Iniciando MicroK8s..."
microk8s start

# Esperar hasta que MicroK8s esté listo
echo "Esperando a que MicroK8s esté listo..."
microk8s status --wait-ready

# Habilitar complementos de MicroK8s
echo "Habilitando complementos de MicroK8s..."
microk8s enable dashboard
microk8s enable dns
microk8s enable registry
microk8s enable istio
microk8s enable ingress
microk8s enable cert-manager
microk8s enable kube-hunter
microk8s enable kube-bench


# Clonar repositorio de GitHub
echo "Clonando repositorio de GitHub..."
git clone https://github.com/RafaelCarrascoPeralta/TFG_yaml.git

echo "Instalación y configuración completa."

EOF

# Configurar PATH
echo "Configurando PATH..."
export PATH=$PATH:/snap/bin

# Añadir usuario al grupo de MicroK8s
echo "Añadiendo usuario al grupo de MicroK8s..."
sudo usermod -a -G microk8s $USER

# Crear nuevo grupo
echo "Creando nuevo grupo..."
newgrp microk8s

# Configurar PATH
echo "Configurando PATH..."
export PATH=$PATH:/snap/bin
