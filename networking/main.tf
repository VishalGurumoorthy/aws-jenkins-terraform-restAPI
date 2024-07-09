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


#Setup Public Route table
resource "aws_route_table" "dev_proj_1_public_route_table" {
  vpc_id = aws_vpc.dev_proj_1_eu_central_1.id
  route {
    cidr_block = "0.0.0.0/0" #Anyone in the internet can access
    gateway_id = aws_internet_gateway.dev_proj-1_public_internet_gateway.id
  }
  tags = {
    Name = "dev-proj-1-public_rt"
  }
}

#Public Route table and Public subnet association
resource "aws_route_table_association" "dev_proj_1_public_rt_subnet_association" {
  count = length(aws_subnet.dev_proj_1_public_subnet)
  subnet_id = aws_subnet.dev_proj_1_public_subnet[count.index].id
  route_table_id = aws_route_table.dev_proj_1_public_route_table.id
}

#Setup private route table (Private subnet)
resource "aws_route_table" "dev_proj_1_private_route_table" {
  vpc_id = aws_vpc.dev_proj_1_eu_central_1.id
  tags = {
    Name = "dev_proj_1_private_rt"
  }
}

#Private Route table and subnet association
resource "aws_route_table_association" "dev_proj_1_private_rt_subnet_association"{
  count = length(aws_subnet.dev_proj_1_private_subnet)
  subnet_id = aws_subnet.dev_proj_1_private_subnet[count.index].id
  route_table_id = aws_route_table.dev_proj_1_private_route_table.id

}
