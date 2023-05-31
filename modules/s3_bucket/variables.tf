variable "environment" {
  type        = string
  description = "Entorno del bucket de S3"
}
variable "region" {
  type = string
}
variable "enable_bucket_policy" {
  type        = bool
  description = "Indica si se habilita la política del bucket de S3"

}
variable "bucket_name" {
  type        = string
  description = "Nombre del bucket de s3"
}
variable "versioning_status" {
  type        = bool
  default     = false
  description = "Indica si se habilita el versionado del bucket de S3"
}
variable "encrypt_with_kms" {
  type        = bool
  description = "Indica si se encrypta con kms"

}
variable "kms_master_key_id" {
  type        = string
  description = "indica el ARN de la kms creada"
  default     = null
}
variable "bucket_policy" {
  type = string
}
