# S3 Bucket
# -----------------------------
resource "aws_s3_bucket" "mlops" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name        = var.bucket_name
    Environment = var.env
    Team        = "MLops"
  }
}

# -----------------------------
# Public Access Block (allow IAM access)
# -----------------------------
resource "aws_s3_bucket_public_access_block" "mlops" {
  bucket = aws_s3_bucket.mlops.id

  # Keep these TRUE to prevent real public access
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# -----------------------------
# Bucket Policy (root user full access)
# -----------------------------
resource "aws_s3_bucket_policy" "mlops_root_access" {
  bucket = aws_s3_bucket.mlops.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "RootFullAccess"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::688349427813:root"  # your root account
        }
        Action   = "s3:*"
        Resource = [
          "${aws_s3_bucket.mlops.arn}",
          "${aws_s3_bucket.mlops.arn}/*"
        ]
      }
    ]
  })
}

# -----------------------------
# Versioning (optional)
# -----------------------------
resource "aws_s3_bucket_versioning" "mlops" {
  bucket = aws_s3_bucket.mlops.id

  versioning_configuration {
    status = "Enabled"
  }
}

# -----------------------------
# Server-Side Encryption (optional)
# -----------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "mlops" {
  bucket = aws_s3_bucket.mlops.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}