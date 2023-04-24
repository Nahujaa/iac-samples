provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.network_config
  tags = {
    Name      = var.network_config
    yor_trace = "392cf7ba-cf1a-46d4-b65a-d24a5ab08689"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.network_config
  availability_zone = "us-west-2a"
  tags = {
    Name      = var.network_config
    yor_trace = "64bc6416-5cfc-4fa5-b314-2fe853a4af56"
  }
}
