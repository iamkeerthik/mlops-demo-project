# env
variable "env" {
  type        = string
  description = "env (dev/stage/prod)"
}

# AWS region
variable "aws_region" {
  type        = string
  description = "AWS region for resources"
}

# Cluster name
variable "cluster_name" {
  type        = string
  description = "EKS Cluster name"
}

# VPC to deploy into (resolved by Name tag)
variable "vpc_name" {
  type        = string
  description = "Name of the VPC to use for EKS"
}

# Public subnet names (resolved by Name tag)
variable "public_subnet_names" {
  type        = list(string)
  description = "List of public subnet names for EKS node groups"
}
