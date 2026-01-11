provider "kubernetes" {
  host                   = aws_eks_cluster.mlops.endpoint
  cluster_ca_certificate = base64decode(
    aws_eks_cluster.mlops.certificate_authority[0].data
  )
  token = data.aws_eks_cluster_auth.mlops.token
}

provider "helm" {
  kubernetes = {
    host                   = aws_eks_cluster.mlops.endpoint
    cluster_ca_certificate = base64decode(
      aws_eks_cluster.mlops.certificate_authority[0].data
    )
    token = data.aws_eks_cluster_auth.mlops.token
  }
}