variable "table_name" {
  description = "The name of the DynamoDB table"
  type        = string
  default     = "state-lock-tfstate-test"
}

variable "read_capacity" {
  description = "The provisioned read capacity for the DynamoDB table"
  type        = number
  default     = 20
}

variable "write_capacity" {
  description = "The provisioned write capacity for the DynamoDB table"
  type        = number
  default     = 20
}

variable "environment" {
  type = string
}