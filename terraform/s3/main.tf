# -----------------------------
# S3 Bucket
# -----------------------------
resource "aws_s3_bucket" "mlops" {
  bucket = var.bucket_name

  force_destroy = true

  tags = {
    Name        = var.bucket_name
    Environment = var.env
    Team        = "MLops"
  }
}

# -----------------------------
# Public Access Block (disabled for testing)
# -----------------------------
resource "aws_s3_bucket_public_access_block" "mlops" {
  bucket = aws_s3_bucket.mlops.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# -----------------------------
# Bucket ACL (make public for testing)
# -----------------------------
resource "aws_s3_bucket_acl" "mlops_public" {
  bucket = aws_s3_bucket.mlops.id
  acl    = "public-read"
}

# -----------------------------
# Versioning
# -----------------------------
resource "aws_s3_bucket_versioning" "mlops" {
  bucket = aws_s3_bucket.mlops.id

  versioning_configuration {
    status = "Enabled"
  }
}

# -----------------------------
# Server-Side Encryption
# -----------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "mlops" {
  bucket = aws_s3_bucket.mlops.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}