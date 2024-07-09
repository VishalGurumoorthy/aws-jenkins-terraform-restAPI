variable "vpc_cidr"{
    type  = string
    description = "Public subnet CIDR value"
}

variable "vpc_name" {
    type = string
    description = "Devops Project 1 VPC 1"
}

variable "cidr_public_subnet" {
    type =  list(string)
    description = "Public subnet CIDR values"
}

variable "cidr_private_subnet" {
    type = list(string)
    description = "Private subnet CIDR values"
}

variable "eu_availability_zone" {
    type = list(string)
    description = "Availability zones"
}