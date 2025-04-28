terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "foo" {
  bucket = "my-tf-log-bucket"
  acl    = "public-read-write"
  tags = {
    Env       = "prod"
    yor_trace = "ebb37dda-a302-4d17-994f-aa7496b80110"
  }
}