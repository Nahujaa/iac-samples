terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"
  tags = {
    Name      = "tf-0.12-for-example"
    Env       = "prod"
    yor_trace = "7db61a6d-df7f-463d-85df-ca491d23d194"
  }
}

resource "aws_s3_bucket" "publics3" {
  // AWS S3 buckets are accessible to public
  acl    = var.acl_file
  bucket = "publics3"
  versioning {
    enabled = true
  }
  tags = {
    Env       = "prod"
    yor_trace = "4571a6ae-0ccf-4324-9fe0-a2d7b79c0b5f"
  }
}

resource "aws_security_group" "allow_tcp" {
  name        = "allow_tcp"
  description = "Allow TCP inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id
  ingress {
    description = "TCP from VPC"
    // AWS Security Groups allow internet traffic to SSH port (22)
    from_port = 99
    to_port   = 99
    protocol  = "tcp"
    cidr_blocks = [
    var.cidr_file]
  }
  tags = {
    Env       = "prod"
    yor_trace = "b6f627e5-7104-46b2-bbec-11b34194f896"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name      = "tf-0.12-for-example"
    Env       = "prod"
    yor_trace = "87de7465-c049-445f-bf27-714ef8ff855a"
  }
}

resource "aws_instance" "ubuntu" {
  count                       = 3
  ami                         = "ami-2e1ef954"
  instance_type               = "t2.micro"
  associate_public_ip_address = (count.index == 1 ? true : false)
  subnet_id                   = aws_subnet.my_subnet.id
  tags = {
    Name      = format("terraform-0.12-for-demo-%d", count.index)
    Env       = "prod"
    yor_trace = "26e0815b-abcd-48e6-b874-2b8007c8d5a5"
  }
}

# This uses the old splat expression
output "private_addresses_old" {
  value = aws_instance.ubuntu.*.private_dns
}

# This uses the new full splat operator (*)
# But this does not work in 0.12 alpha-1 or alpha-2
/*output "private_addresses_full_splat" {
  value = [ aws_instance.ubuntu[*].private_dns ]
}*/

# This uses the new for expression
output "private_addresses_new" {
  value = [
    for instance in aws_instance.ubuntu :
    instance.private_dns
  ]
}

# This uses the new conditional operator
# that can work with lists
# It should work with lists in [x, y, z] form, but does not yet do that
output "ips" {
  value = [
    for instance in aws_instance.ubuntu :
    (instance.public_ip != "" ? list(instance.private_ip, instance.public_ip) : list(instance.private_ip))
  ]
}
