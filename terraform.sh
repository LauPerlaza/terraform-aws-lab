#!/bin/bash

#se verifica la cantidad de argumentos que se pasan al script utilizando $#, que representa el número de argumentos. Si la cantidad de argumentos es diferente de 2, se muestra un mensaje de uso y se sale del script con exit 1 para indicar un error.

if [ $# -ne 2 ]; then
  echo "Uso: ./script <región> <entorno>"
  exit 1
fi

# Asignar los argumentos a variables
region=$1
environment=$2


#La opción -backend-config se utiliza para proporcionar configuraciones específicas del backend de Terraform durante la inicialización del directorio de trabajo de Terraform.
# Iniciar el directorio del proyecto de Terraform con las variables de región y entorno
echo "Iniciando el directorio del proyecto de Terraform con la región '$region' y el entorno '$environment'..."
terraform init -backend-config="region=$region" -backend-config="environment=$environment"
echo "Se ha iniciado el directorio del proyecto de Terraform."

# Ejecutar el plan de Terraform con las variables de región y entorno
echo "Ejecutando el plan de Terraform con los siguientes valores:"
echo "Región: $region"
echo "Entorno: $environment"
terraform plan -var "region=$region" -var "environment=$environment"
echo "Se ha ejecutado el plan de Terraform."

