variable "vpc_cidr" {}
variable "vpc_name" {}
variable "cidr_public_subnet" {}
variable "eu_availability_zone" {}
variable "cidr_private_subnet" {}


output "dev_proj_1_vpc_id" {
  value = aws_vpc.dev_proj_1_eu_central_1.*.id
}

output "dev_proj_1_public_subnet" {
  value = aws_subnet.dev_proj_1_private_subnet.*.id
}

output "dev_proj_1_private_subnet" {
  value = aws_subnet.dev_proj_1_private_subnet.*.cidr_block
}
#Setup VPC
resource "aws_vpc" "dev_proj_1_eu_central_1" {
    cidr_block = var.vpc_cidr
    tags = {
      Name = var.vpc_name
    }
}


#Setup public subnet
resource "aws_subnet" "dev_proj_1_public_subnet"{
    count = length(var.cidr_public_subnet)
    vpc_id = aws_vpc.dev_proj_1_eu_central_1.id
    cidr_block = element(var.cidr_public_subnet, count.index)
    availability_zone = element(var.eu_availability_zone , count.index)

    tags = {
      Name = "dev-proj-public-subnet-${count.index+1}"
    }
}

#Setup Private subnet
resource "aws_subnet" "dev_proj_1_private_subnet"{
  count = length(var.cidr_private_subnet)
  vpc_id = aws_vpc.dev_proj_1_eu_central_1.id
  cidr_block = element(var.cidr_private_subnet, count.index)
  availability_zone = element(var.eu_availability_zone , count.index)

  tags = {
    Name = "dev-proj-private-subnet-${count.index+1}"
  }
}


#setup internet gateway
resource "aws_internet_gateway" "dev_proj-1_public_internet_gateway"{
  vpc_id = aws_vpc.dev_proj_1_eu_central_1.id
  tags = {
    Name = "dev-proj-1-igw"
  }
}
