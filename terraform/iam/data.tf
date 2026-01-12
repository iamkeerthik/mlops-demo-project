data "aws_eks_cluster" "eks" {
  name = "${var.env}-mlops-cluster"
}

data "aws_eks_cluster_auth" "eks" {
  name = "${var.env}-mlops-cluster"
}

# IAM OIDC for service accounts
data "aws_iam_openid_connect_provider" "oidc" {
  url = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
}