variable "region" {
  type        = string
  description = "Region"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Entorno de la infraestructura"
}
variable "vpc_name" {
  type = string
  description = "Nombre de la VPC"
}

variable "ip" {
  type        = string
  description = "ip"
}