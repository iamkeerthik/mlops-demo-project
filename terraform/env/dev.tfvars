aws_region = "ap-south-1"
env        = "dev"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
#private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]


cluster_name        = "dev-mlops"

vpc_name            = "dev-mlops-vpc"
public_subnet_names = ["dev-public-subnet-1", "dev-public-subnet-2"]

bucket_name     = "mlops-prod-artifacts-keerth"