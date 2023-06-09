#Esta variable se utiliza para especificar el entorno del bucket de S3
variable "environment" {
  type        = string
  description = "Entorno del bucket de S3"
}
#Esta variable se utiliza para especificar la región en la que se creará el bucket de S3
variable "region" {
  type = string
}
#sta variable se utiliza para indicar si se habilita la política del bucket de S3.
# El tipo de variable se establece en bool,
# lo que significa que espera un valor booleano (true o false). 
variable "enable_bucket_policy" {
  type        = bool
  description = "Indica si se habilita la política del bucket de S3"
}
#Esta variable se utiliza para especificar el nombre del bucket de S3
variable "bucket_name" {
  type        = string
  description = "Nombre del bucket de s3"
}
# Esta variable se utiliza para indicar si se habilita el versionado del bucket de S3. 
#El tipo de variable se establece en bool, lo que significa que espera un valor booleano (true o false).
# El valor predeterminado se establece en false.
variable "versioning_status" {
  type        = bool
  default     = false
  description = "Indica si se habilita el versionado del bucket de S3"
}
#Esta variable se utiliza para indicar si se encripta el bucket de S3 con KMS.
#El tipo de variable se establece en bool, lo que significa que espera un valor booleano (true o false)
variable "encrypt_with_kms" {
  type        = bool
  description = "Indica si se encrypta con kms"
}
#Esta variable se utiliza para especificar el ARN de la clave de KMS 
#que se utilizará para encriptar el bucket de S3
#El valor predeterminado se establece en null, lo que significa que no se proporciona un valor predeterminado
variable "kms_master_key_id" {
  type        = string
  description = "indica el ARN de la kms creada"
  default     = null
}
#Esta variable se utiliza para especificar la política del bucket de S3
variable "bucket_policy" {
  type = string
  description = "especifica la política del bucket de S3"
}
