variable "environment" {
  type = string
}
variable "user-name" {
  type = string
}
variable "multi_az" {
  type = bool
}
variable "name" {
  type = string
}
variable "availability_zone" {
  type = string
}
variable "subnet_ids" {
  type = list(any)
}
variable "engine" {
  type = string
}
variable "engine_version" {
  type = string
}
variable "instance_class" {
  type = string
}
variable "vpc_id" {
  type = string
}

variable "cidr_to_allow" {
  type = string
}