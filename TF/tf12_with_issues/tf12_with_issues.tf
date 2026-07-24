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
    yor_trace = "19313d34-efce-4691-a327-cb7c1f46fad0"
  }
}