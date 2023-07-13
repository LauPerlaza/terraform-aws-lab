terraform {
  backend "s3" {
    bucket         = "state-tf-tes-lab"
    dynamodb_table = "tfstate-table"
    key            = "terraform-tfstate"
    region         = "us-east-1"
  }
}