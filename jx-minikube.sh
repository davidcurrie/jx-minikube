#!/bin/bash

# Clean up
minikube delete
pkill -f autossh

# Create cluster
jx create cluster minikube --prow --batch-mode \
  --cpu 4 --memory 8192 --disk-size 150GB --vm-driver hyperkit \
  --git-username demo-bot --domain serveo.currie.cloud

# Scale down extra replicas
kubectl scale --replicas 1 deploy/hook deploy/deck

# Set-up tunnelling
watch -n 10 ./serveo.sh