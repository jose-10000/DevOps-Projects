
# VPC
resource "aws_vpc" "VPC-test1" {
  cidr_block           = var.cidr_vpc
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = {
    Name        = "VPC-test1.terraform"
    Environment = "${var.environment_tag}"
  }

}

# Subnet
resource "aws_subnet" "subnet_public" {
  vpc_id                  = aws_vpc.VPC-test1.id
  cidr_block              = var.cidr_subnet
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zone
  tags = {
    Environment = var.environment_tag
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw-test1" {
  vpc_id = aws_vpc.VPC-test1.id
  tags = {
    Name        = "IGW-terraform"
    Environment = var.environment_tag
  }
}


# Route Table
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.VPC-test1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-test1.id
  }
  tags = {
    Environment = var.environment_tag
  }
}

resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_security_group" "sg_22" {
  name   = "sg_22"
  vpc_id = aws_vpc.VPC-test1.id

  # SSH access from the VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Environment" = var.environment_tag
  }
}


