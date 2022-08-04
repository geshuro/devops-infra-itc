#!/bin/bash
#
# Descripcion: Script para instalar https://github.com/kubernetes/kubernetes/issues/61486
# Requesito: kubectl instalado y configurado sobre el cluster de EKS y incluido en el PATH

KUBECTL='which kubectl'

if [ $? -ne 0 ]; then
  echo "Kubectl is not installed; exiting"
  exit 1
else
  echo "Using kubectl found at KUBECTL"
fi

echo "Installing Kubectl Patch "
kubectl -n kube-system patch daemonset kube-proxy --patch "$(cat $path/nodeport-local-patch.yml)"
if [ $? -ne 0 ]; then
  echo "Kubectl patch not installed; exiting"
  exit 1
else
  echo "Kubectl patch installed"
fi

