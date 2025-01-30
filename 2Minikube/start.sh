#!/bin/bash

# Function to prompt user
ask_user() {
    while true; do
        read -p "$1 (yes/no): " choice
        case "$choice" in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Ask user if they want to install Minikube
if ask_user "Do you want to install Minikube?"; then
    echo "Starting Minikube..."
    minikube start
    echo "Minikube setup completed."
else
    echo "Skipping Minikube installation."
    exit 0
fi

# Ask user if they want to install ArgoCD
if ask_user "Do you want to install ArgoCD in Minikube?"; then
    echo "Installing ArgoCD..."
    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    echo "ArgoCD installation completed."
else
    echo "Skipping ArgoCD installation."
fi

echo "Script execution completed."
