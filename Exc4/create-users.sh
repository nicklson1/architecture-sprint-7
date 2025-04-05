#!/bin/bash

# NOTE: Пользователи и авторизация RBAC в Kubernetes 
# https://habr.com/ru/companies/flant/articles/470503/

# Создание и аутентификация пользователей с помощью клиентских сертификатов X.509
# 1. Создание секретного ключа пользователя и запроса на подпись сертификата;
# 2. Заверение его в центре сертификации (Kubernetes CA) для получения сертификата пользователя;
# 3. Создайте пользователя внутри Kubernetes.
# 4. Задайте контекст для пользователя.
create_user() {
    USERNAME=$1
    GROUP=$2
    NAMESPACE=$2

    # Генерация приватного ключа
    openssl genrsa -out certs/${USERNAME}.key 2048

    # Создание CSR
    openssl req -new -key certs/${USERNAME}.key \
        -out certs/${USERNAME}.csr \
        -subj "/CN=${USERNAME}/O=${GROUP}"

    # Подпись сертификата через CA кластера
    sudo openssl x509 -req -in certs/${USERNAME}.csr \
        -CA ~/.minikube/ca.crt \
        -CAkey ~/.minikube/ca.key \
        -CAcreateserial \
        -out certs/${USERNAME}.crt -days 365

    # Создание kubeconfig для пользователя
    kubectl config set-credentials ${USERNAME} \
        --client-certificate=certs/${USERNAME}.crt \
        --client-key=certs/${USERNAME}.key

    kubectl config set-context ${USERNAME}@${NAMESPACE} \
        --cluster=kubernetes \
        --namespace=${NAMESPACE} \
        --user=${USERNAME}        
}

# папка для сертификатов
mkdir -p certs

# Создание пользователей
generate_user_cert "superadmin" "superadmin" "minikube"
generate_user_cert "devops" "devops" "dev"
generate_user_cert "dev" "dev" "dev"
generate_user_cert "readonly" "readonly" "dev"