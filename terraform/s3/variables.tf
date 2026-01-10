variable "aws_region" {
  type = string
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name"
}

# env
variable "env" {
  type        = string
  description = "env (dev/stage/prod)"
}
