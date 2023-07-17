terraform {
  backend "s3" {
    bucket         = "test-tf-state"
    dynamodb_table = "table-terraform-tf"
    key            = "terraform-tfstate"
    region         = "us-east-1"
  }
}