#!/bin/bash

# Создание namespace dev
kubectl create namespace dev

# Создание сервисов
kubectl run front-end-app --image=nginx --labels=role=front-end --expose --port 80 -n dev
kubectl run back-end-api-app --image=nginx --labels=role=back-end-api --expose --port 80 -n dev
kubectl run admin-front-end-app --image=nginx --labels=role=admin-front-end --expose --port 80 -n dev
kubectl run admin-back-end-api-app --image=nginx --labels=role=admin-back-end-api --expose --port 80 -n dev
