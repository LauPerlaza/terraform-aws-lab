variable "environment" {
  type = string
}
variable "region" {
  type = string
}
variable "enable_bucket_policy" {
  type        = bool
  description = "Política del bucket de S3"

}
variable "bucket_name" {
  type        = string
  description = "Nombre del bucket de s3"
}
variable "versioning_status" {
  type        = bool
  default     = "false"
  description = "Indica si se habilita el versionado del bucket de S3"

}
