data "aws_eks_cluster" "mlops_cluster" {
  name = "${var.env}-mlops-cluster"
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = data.aws_eks_cluster.mlops_cluster.name
}