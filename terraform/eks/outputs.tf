# -----------------------------
# Cluster Outputs
# -----------------------------
output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.mlops.name
}

output "eks_cluster_endpoint" {
  description = "The endpoint URL of the EKS cluster"
  value       = aws_eks_cluster.mlops.endpoint
}

output "eks_cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = aws_eks_cluster.mlops.arn
}

# -----------------------------
# Node Group Outputs
# -----------------------------
output "eks_node_group_name" {
  description = "The name of the managed node group"
  value       = aws_eks_node_group.mlops_nodes.node_group_name
}

output "eks_node_group_arn" {
  description = "The ARN of the managed node group"
  value       = aws_eks_node_group.mlops_nodes.arn
}

output "eks_node_group_role_arn" {
  description = "The IAM role ARN attached to the node group"
  value       = aws_iam_role.eks_node_role.arn
}