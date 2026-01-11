data "aws_eks_cluster" "eks" {
  name = "${var.env}-mlops-cluster"
}

data "aws_eks_cluster_auth" "eks" {
  name = "${var.env}-mlops-cluster"
}

data "aws_vpc" "eks_vpc" {
  id = data.aws_eks_cluster.eks.vpc_config[0].vpc_id
}

data "aws_subnets" "eks_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks_vpc.id]
  }
}