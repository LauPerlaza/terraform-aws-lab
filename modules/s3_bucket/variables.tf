variable "environment" {
  type = string
}
variable "versioning_status" {
  type = bool
}
variable "region" {
  type = string
}
variable "encrypt_with_kms" {
  type = bool
}
variable "kms_arn" {
  type = string
}
variable "enable_bucket_policy" {
  type = bool
}
variable "bucket_name" {
  type = string
}