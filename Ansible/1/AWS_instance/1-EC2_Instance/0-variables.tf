# Variables
# Region
variable "aws_region" {
  default = "eu-west-1"
}

# Profile, used to authenticate to AWS.
# This is the profile name in ~/.aws/credentials
variable "aws_profile" {
  default = "terraform-course"
}

variable "configuration" {
  description = "The total configuration, List of Objects/Dictionary"
  default     = [{}]
}

# Instance
variable "host_name" {
  description = "Name of the instance to be created"
  default     = "Server"
}

variable "instance_name" {
  description = "Name of the instance to be created"
  default     = "Ansible-Server"
}



variable "instance_type" {
  default = "t2.micro" # t2.micro // 1 vCPU, 1 GiB RAM // eu-west-1
}

variable "subnet_id" {
  description = "The VPC subnet the instance(s) will be created in"
  default     = "subnet-Ansible-Server"
}

variable "ami_id" {
  description = "The AMI to use"
  # default     = "ami-0c90138cdc75f84d2"  // Ansible-Ubuntu-22.04-LTS // eu-west-1
  default = "ami-0d31449d0dd5f363f" # Debian 11 // eu-west-1    
}

variable "ami_id2" {
  description = "The AMI to use"
  default     = "ami-01dd271720c1ba44f" # Ubuntu 22.04 LTS // eu-west-1    
}

variable "number_of_instances" {
  description = "number of instances to be created"
  default     = 3
}

# VPC and subnet.
variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}
variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default     = "10.1.0.0/24"
}
variable "availability_zone" {
  description = "availability zone to create subnet"
  default     = "eu-west-1a"
}
variable "public_key_path" {
  description = "Public key path"
  default     = "~/.ssh/ansible.pub"
}

variable "environment_tag" {
  description = "Environment tag"
  default     = "dev"
}

# Security group
variable "ingressports" {
  type    = list(number)
  default = [8080, 22, 80, 443]
}

variable "ingressports_udp" {
  type    = list(number)
  default = [443]
}

