terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "foo" {
  bucket = "my-tf-log-bucket"
  acl    = "private"
  versioning {
    enabled = true
  }
  logging {
    target_bucket = "logging_bucket"
    target_prefix = "log/"
  }
  tags = {
    yor_trace = "97e5ab89-7358-4ddb-83c0-e0c61543ce3c"
  }
}