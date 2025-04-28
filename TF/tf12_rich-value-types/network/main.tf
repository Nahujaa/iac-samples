provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.network_config
  tags = {
    Name      = var.network_config
    Env       = "prod"
    yor_trace = "12c42444-54af-46e4-a2fd-25a9f8f7bc4d"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.network_config
  availability_zone = "us-west-2a"
  tags = {
    Name      = var.network_config
    Env       = "prod"
    yor_trace = "85d6271a-3986-403d-a3db-0dc69a4962ec"
  }
}
