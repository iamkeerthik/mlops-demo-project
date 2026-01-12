# Loop through each bucket in the map
resource "aws_s3_bucket" "mlops" {
  for_each     = var.buckets
  bucket       = each.value
  force_destroy = true

  tags = {
    Name        = each.value
    Environment = var.env
    Team        = "MLops"
  }
}

# Public Access Block
resource "aws_s3_bucket_public_access_block" "mlops" {
  for_each = aws_s3_bucket.mlops
  bucket   = each.value.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bucket Policy (root full access)
resource "aws_s3_bucket_policy" "mlops_root_access" {
  for_each = aws_s3_bucket.mlops
  bucket   = each.value.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "RootFullAccess"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::688349427813:root"
        }
        Action   = "s3:*"
        Resource = [
          "${each.value.arn}",
          "${each.value.arn}/*"
        ]
      }
    ]
  })
}

# Versioning
resource "aws_s3_bucket_versioning" "mlops" {
  for_each = aws_s3_bucket.mlops
  bucket   = each.value.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "mlops" {
  for_each = aws_s3_bucket.mlops
  bucket   = each.value.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}