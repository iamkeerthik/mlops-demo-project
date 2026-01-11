# VPC
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.this.id
}

# Public Subnet IDs
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for s in aws_subnet.public : s.id]
}

# Private Subnet IDs (may be empty if no private subnets)
output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for s in aws_subnet.private : s.id]
}

# NAT Gateway ID (if created)
output "nat_gateway_id" {
  description = "NAT Gateway ID (if private subnets exist)"
  value       = length(aws_nat_gateway.this) > 0 ? aws_nat_gateway.this[0].id : ""
}


output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}