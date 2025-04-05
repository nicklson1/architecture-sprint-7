#!/bin/bash

FRONTEND_POD=front-end-app
FRONTEND_POD_ADMIN=admin-front-end-app
BACKEND_POD=back-end-api-app
BACKEND_POD_ADMIN=admin-back-end-api-app

echo "Test connection from Frontent to Backend"
kubectl exec -it -n dev ${FRONTEND_POD} -- curl -o - -I "http://${BACKEND_POD}"

echo "Test connection from Backend to Frontent"
kubectl exec -it -n dev ${BACKEND_POD} -- curl -o - -I "http://${FRONTEND_POD}"

echo "Test connection from Admin Frontent to Admin Backend"
kubectl exec -it -n dev ${FRONTEND_POD_ADMIN} -- curl -o - -I "http://${BACKEND_POD_ADMIN}"

echo "Test connection from Admin Backend to AdminFrontent"
kubectl exec -it -n dev ${BACKEND_POD_ADMIN} -- curl -o - -I "http://${FRONTEND_POD_ADMIN}"
