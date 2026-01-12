output "sagemaker_domain_id" {
  value = aws_sagemaker_domain.mlops_domain.id
}

output "sagemaker_user_profile_name" {
  value = aws_sagemaker_user_profile.mlops_user.user_profile_name
}

output "sagemaker_exec_role_arn" {
  value = aws_iam_role.sagemaker_exec_role.arn
}