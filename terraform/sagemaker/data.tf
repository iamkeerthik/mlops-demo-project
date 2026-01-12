# Fetch the EKS cluster
data "aws_eks_cluster" "eks" {
  name = "${var.env}-mlops-cluster"
}

data "aws_eks_cluster_auth" "eks" {
  name = data.aws_eks_cluster.eks.name
}

# Fetch the VPC ID of the EKS cluster
data "aws_vpc" "eks_vpc" {
  id = data.aws_eks_cluster.eks.vpc_config[0].vpc_id
}

# Fetch the subnets associated with the EKS cluster
data "aws_subnets" "eks_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks_vpc.id]
  }
}