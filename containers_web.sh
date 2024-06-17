#!/bin/bash

microk8s kubectl apply -f /home/admin/TFG_yaml/secret.yaml
microk8s kubectl apply -f /home/admin/TFG_yaml/deployment.yaml
microk8s kubectl apply -f /home/admin/TFG_yaml/service.yaml
microk8s kubectl apply -f /home/admin/TFG_yaml/ingress.yaml

