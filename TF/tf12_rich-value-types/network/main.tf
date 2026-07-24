provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.network_config
  tags = {
    Name      = var.network_config
    Env       = "prod"
    yor_trace = "2bf0b14e-4f42-4971-8c01-e48145b8c919"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.network_config
  availability_zone = "us-west-2a"
  tags = {
    Name      = var.network_config
    Env       = "prod"
    yor_trace = "c8fe032c-dd9f-44c3-b9a5-19febbd85f4c"
  }
}
