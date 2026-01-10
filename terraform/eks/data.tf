data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "eks_node_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# -----------------------------
# Resolve VPC by Name
# -----------------------------
data "aws_vpc" "mlops_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# -----------------------------
# Resolve public subnets by Name
# -----------------------------
data "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_names)
  filter {
    name   = "tag:Name"
    values = [var.public_subnet_names[count.index]]
  }
}


