resource "aws_sagemaker_domain" "mlops_domain" {
  domain_name = "${var.env}-mlops-domain"
  auth_mode   = "IAM"

  default_user_settings {
    execution_role = aws_iam_role.sagemaker_exec_role.arn
  }

  # Use the VPC and subnets from EKS
  vpc_id     = data.aws_vpc.eks_vpc.id
  subnet_ids = data.aws_subnets.eks_subnets.ids

  tags = merge(var.tags, { Environment = var.env })
}