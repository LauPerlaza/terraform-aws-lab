#Esta variable se utiliza para especificar la región en la que se crearán los 
#recursos de AWS. El tipo de variable se establece en string,
#lo que significa que espera un valor de cadena. 
variable "region" {
  type        = string
  description = "Region"
  default     = "us-east-1"
}
#Esta variable se utiliza para especificar el entorno en el 
#que se están desplegando los recursos de infraestructura.
variable "environment" {
  type    = string
  default = "test"
}
#Esta variable se utiliza para especificar si se debe utilizar el servicio de KMS
#para el cifrado del bucket de S3. El tipo de variable se establece en bool, 
#lo que significa que espera un valor booleano (verdadero o falso)
variable "encrypt_with_kms" {
  type        = bool
  default     = false
  description = "ARN de la clave KMS para el cifrado del bucket de S3"

}
