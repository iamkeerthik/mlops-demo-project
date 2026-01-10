# -----------------------------
# EKS Cluster
# -----------------------------
resource "aws_eks_cluster" "mlops" {
  name     = "${var.env}-${var.cluster_name}"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.28"

  vpc_config {
    subnet_ids = local.public_subnet_ids
  }

  tags = {
    Name = var.cluster_name
    Env  = var.env
  }
}

# -----------------------------
# EKS Managed Node Group
# -----------------------------
resource "aws_eks_node_group" "mlops_nodes" {
  cluster_name    = aws_eks_cluster.mlops.name
  node_group_name = "${var.env}-${var.cluster_name}-ng"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = local.public_subnet_ids
  ami_type        = "AL2_x86_64"

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }

  instance_types = ["t3.medium"]
  disk_size      = 20

  tags = {
    Name = "${var.cluster_name}-node"
    Env  = var.env
  }

  depends_on = [aws_eks_cluster.mlops] # ensures cluster exists first
}