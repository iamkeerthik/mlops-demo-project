variable "region" {
  type = string
  default = "ap-south-1"
}
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

resource "aws_iam_role" "alb_controller" {
  name = "${var.env}-alb-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach pre-existing AWS policy
resource "aws_iam_role_policy_attachment" "alb_controller_attach" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLoadBalancerControllerIAMPolicy"
}

resource "kubernetes_service_account_v1" "alb_controller" {
  metadata {
    name      = "alb-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller.arn
    }
  }
}

resource "helm_release" "alb_controller" {
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  namespace        = "kube-system"
  create_namespace = false
  wait             = true
  timeout          = 600

  values = [
    yamlencode({
      clusterName    = "${var.env}-mlops-cluster"
      serviceAccount = { create = false, name = "aws-load-balancer-controller" }
      region         = var.region
      vpcId          = data.aws_vpc.eks_vpc.id
      replicaCount   = 1
    })
  ]
}