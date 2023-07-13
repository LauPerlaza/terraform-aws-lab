#!/bin/bash

# Configurar variables
bucket_name="test-tf-state"
table_name="table-terraform-tf"
region="us-east-1"

# Crear el bucket de S3
aws s3api create-bucket --bucket $bucket_name --region $region

# Habilitar el control de versiones para el bucket de S3
aws s3api put-bucket-versioning --bucket $bucket_name --region $region --versioning-configuration Status=Enabled

# Crear la tabla de DynamoDB
aws dynamodb create-table --table-name $table_name --region $region --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST
