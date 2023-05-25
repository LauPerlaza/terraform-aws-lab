variable "ami" {
  default     = "ami-07a92b65064ead2f2"
  type        = string
  description = "ami_ec2"
}
variable "instance_type" {
  type        = string
  description = "instance_type"
}
variable "subnet_id" {
  type        = string
  description = "subnet_id_public"
}
variable "sg_ids" {
  type = list(any)
}
variable "name" {
  type = string
}
variable "environment" {
  type = string
}
