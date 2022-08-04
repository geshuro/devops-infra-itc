#!/bin/bash
#
# Descripcion: Script para instalar Istio usando istioclt
# Requesito: istioctl instalado y incluido en el PATH

ISTIOCTL='which istioctl'

if [ $? -ne 0 ]; then
  echo "Istioctl is not installed; exiting"
  exit 1
else
  echo "Using Istioctl found at $ISTIOCTL"
fi

echo "Installing Istio in $profile "
istioctl install --set profile="$profile"
if [ $? -ne 0 ]; then
  echo "Istioctl is not installed; exiting"
  exit 1
else
  echo "Istioctl installed in profile $profile"
fi

kubectl label namespace default istio-injection=enabled
