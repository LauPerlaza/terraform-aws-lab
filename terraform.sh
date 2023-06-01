# ! bin/bash 
#Programa para correr los comandos de terraform 

#ruta al directorio del proyecto de terraform 

terraform_dir="C:/Users/Laura Perlaza/Documents/terraform-aws-lab"

#cambia al directorio del proyecto de terraform 

cd "terraform_dir"

#iniciar el dorectorio del proyecto de terraform 
terraform init

echo "acaba de iniciar el directorio de proyecto de terraform"

#ejecutar el plan de terraform
terraform plan

echo "acaba de ejecutar el plan de terraform"

