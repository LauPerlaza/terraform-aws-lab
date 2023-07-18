#!/bin/bash

# Configurar variables.

bucket_name="test-terraf-state"
table_name="table-terraform-tf"
region="us-east-1"

# Verificar si el bucket ya existe
bucket_exists=$(aws s3api head-bucket --bucket "$bucket_name" --region "$region" 2>&1)
if [[ $bucket_exists == *"Not Found"* ]]; then
  # El bucket no existe, crearlo
  aws s3api create-bucket --bucket "$bucket_name" --region "$region"
  aws s3api put-bucket-versioning --bucket "$bucket_name" --region "$region" --versioning-configuration Status=Enabled
  echo "Bucket creado: $bucket_name"
else
  echo "El bucket $bucket_name ya existe."
fi

# Verificar si la tabla ya existe
table_exists=$(aws dynamodb describe-table --table-name "$table_name" --region "$region" 2>&1)
if [[ $table_exists == *"TableNotFoundException"* ]]; then

# La tabla no existe, crearla
  aws dynamodb create-table --table-name "$table_name" --region "$region" --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST
  echo "Tabla creada: $table_name"
else
  echo "La tabla $table_name ya existe."
fi
