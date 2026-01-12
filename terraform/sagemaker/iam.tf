# SageMaker Execution Role
resource "aws_iam_role" "sagemaker_exec_role" {
  name = "${var.env}-sagemaker-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

# Attach managed policies for S3 and CloudWatch
resource "aws_iam_role_policy_attachment" "sagemaker_s3_attach" {
  role       = aws_iam_role.sagemaker_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "sagemaker_cw_attach" {
  role       = aws_iam_role.sagemaker_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

# Custom ABAC policy for tag-based access
resource "aws_iam_policy" "sagemaker_abac" {
  name        = "${var.env}-sagemaker-abac"
  description = "ABAC for SageMaker resources"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sagemaker:*",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:ResourceTag/Environment" = var.env
          }
        }
      }
    ]
  })
}

# Attach ABAC policy to execution role
resource "aws_iam_role_policy_attachment" "sagemaker_abac_attach" {
  role       = aws_iam_role.sagemaker_exec_role.name
  policy_arn = aws_iam_policy.sagemaker_abac.arn
}