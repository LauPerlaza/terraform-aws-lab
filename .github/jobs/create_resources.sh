#!/bin/bash

#si no se define la variable de entorno ENVIRONMENT, se usará automáticamente -
#el valor predeterminado "Develop" para construir los nombres del bucket y la tabla DynamoDB.
ENVIRONMENT=${ENVIRONMENT:-"develop"}

BUCKET_NAME="terralab-$ENVIRONMENT-test-01"
DYNAMODB_TABLE="dynamodb-table-$ENVIRONMENT-test"
AWS_REGION="us-east-1"

# Verificar si el bucket ya existe

bucket_exists="$(aws s3api head-bucket --bucket "$BUCKET_NAME" --region "$AWS_REGION" 2>&1)" 
echo $bucket_exists 
if [[ $bucket_exists == *"Not Found"* ]]; then

# El bucket no existe, crearlo
  aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$AWS_REGION"
  aws s3api put-bucket-versioning --bucket "$BUCKET_NAME" --region "$AWS_REGION" --versioning-configuration Status=Enabled
  echo "Bucket creado: $BUCKET_NAME"
else
  echo "El bucket $BUCKET_NAME ya existe."
fi

# Verificar si la tabla ya existe
table_exists="$(aws dynamodb describe-table --table-name "$DYNAMODB_TABLE" --region "$AWS_REGION" 2>&1)"
echo $table_exists
if [[ $table_exists == *"Requested resource not found"* ]]; then

# La tabla no existe, crearla
  aws dynamodb create-table --table-name "$DYNAMODB_TABLE" --region "$AWS_REGION" --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST
  echo "Tabla creada: $DYNAMODB_TABLE"
else
  echo "La tabla $DYNAMODB_TABLE ya existe."
fi