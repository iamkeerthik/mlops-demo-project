variable "env" {
  type        = string
  description = "Environment name (dev/stage/prod)"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDRs"
  default     = []
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnet CIDRs"
  default     = []
}