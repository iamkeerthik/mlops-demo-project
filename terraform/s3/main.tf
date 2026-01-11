# -----------------------------
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
# Disable Block Public Access
# -----------------------------
resource "aws_s3_bucket_public_access_block" "mlops" {
  bucket = aws_s3_bucket.mlops.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# -----------------------------
# Full Public Access Policy (read/write/delete)
# -----------------------------
resource "aws_s3_bucket_policy" "mlops_public" {
  bucket = aws_s3_bucket.mlops.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "FullPublicAccess"
        Effect    = "Allow"
        Principal = "*"               # Anyone can access
        Action    = [
          "s3:*"                     # Full S3 actions
        ]
        Resource  = [
          "${aws_s3_bucket.mlops.arn}",        # Bucket itself
          "${aws_s3_bucket.mlops.arn}/*"       # All objects
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