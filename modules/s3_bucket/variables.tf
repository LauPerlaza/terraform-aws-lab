variable "environment" {
  type = string
}
variable "region" {
  type = string
}
variable "enable_bucket_policy" {
  type = bool
}
variable "bucket_name" {
  type = string
}
variable "versioning_status" {
  type = bool
  default = "false"
}
