terraform{
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "5.57.0"
      }
    }
}

provider "aws"{
    region = "eu-west-1"
    shared_credentials_files = ["C:/Users/Vishal/dev/DevOps/projects/jenkin_terraform/.aws/credentials"]
    
}