module "networking" {
    source = "./networking"
    vpc_cidr = var.vpc_cidr
    vpc_name = var.vpc_name
    cidr_public_subnet = var.cidr_public_subnet
    eu_availability_zone  = var.eu_availability_zone
    cidr_private_subnet = var.cidr_private_subnet
    
}
