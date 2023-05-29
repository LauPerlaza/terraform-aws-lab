variable "region" {
  type        = string
  description = "Region"
  default = "us-east-1"
}
variable "environment" {
  type = string
}
variable "encrypt_with_kms" {
  type = bool 
  default = false
}
