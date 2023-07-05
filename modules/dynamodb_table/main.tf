resource "aws_dynamodb_table" "dynamodb-table-test" {
  name           = var.table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = "LockId"

  attribute {
    name = "LockId"
    type = "S"
  }
  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }
tags = {
    Name        = "dynamodb-table-test_${var.environment}"
    Environment = "dev"
  }
}