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
    yor_trace = "cc1a2b5c-591c-4d6a-8bf0-22f3a3bc5ed0"
  }
}

resource "aws_s3_bucket" "publics3" {
  acl    = var.acl
  bucket = "publics3"
  versioning {
    enabled = true
  }
  tags = {
    yor_trace = "b6e54ed4-971e-4af0-b530-896fc8469799"
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
    var.cidr]
  }
  tags = {
    yor_trace = "5bf24be0-0259-45d2-8e53-96319e8e6dbd"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name      = "tf-0.12-for-example"
    yor_trace = "f60d6c24-39ae-445c-826a-24574f4ce4e9"
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
    yor_trace = "9c7c3025-cac8-4d49-a5cf-1a3ebdf4a310"
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
