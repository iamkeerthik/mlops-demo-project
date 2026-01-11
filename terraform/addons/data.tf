data "aws_eks_cluster_auth" "mlops" {
  name = aws_eks_cluster.mlops.name
}