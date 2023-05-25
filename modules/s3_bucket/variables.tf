variable "environment" {
    type = string
}
variable  "versioning_status" {
    type = bool
}
variable "region" {
  type = string
}
variable "encrypt_with_kms" {
  type = string
}
variable "kms_arn" {
  type = string
}
variable "enable_bucket_policy" {
  type = string
}