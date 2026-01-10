# Collect subnet IDs
locals {
  public_subnet_ids = [for s in data.aws_subnet.public_subnets : s.id]
}