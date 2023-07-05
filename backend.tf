terraform {
  backend "s3" {
    bucket         = "tfstate-test"
    dynamodb_table = "state-lock-tfstate-test"
    key            = "testing/aws-s3-bucket.tfstate"
    region         = "us-west-2"
  }
}