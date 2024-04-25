provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.network_config
  tags = {
    Name      = var.network_config
    yor_trace = "437a749c-1cb5-49ff-91eb-e5a145ef55fb"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.network_config
  availability_zone = "us-west-2a"
  tags = {
    Name      = var.network_config
    yor_trace = "a00f0e51-7bdb-4743-a16f-cedbe068f68c"
  }
}
