variable "buckets" {
  description = "Map of S3 buckets to create"
  type        = map(string)
  default     = {
    dev_intent   = "mlops-intent-dev"
    dev_model1   = "mlops-model1-dev"
  }
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "dev"
}