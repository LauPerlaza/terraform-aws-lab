terraform {
  backend "s3" {
    bucket         = "test-terraf-state-lab"
    dynamodb_table = "table-terraform-tf"
    key            = "terraform-tfstate"
    region         = "us-east-1"
  }
}