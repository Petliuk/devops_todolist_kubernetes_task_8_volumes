#!/bin/bash

kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/confgiMap.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f pv.yml
kubectl apply -f pvc.yml
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/hpa.yml
