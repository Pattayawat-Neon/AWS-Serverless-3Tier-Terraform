resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "daily-finance-lambda-bucket-${var.env}"
}

resource "aws_s3_bucket_versioning" "lambda_bucket_versioning" {
  bucket = aws_s3_bucket.lambda_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = "daily-finance-tfstate-${var.env}"
}

resource "aws_s3_bucket_versioning" "tfstate_bucket_versioning" {
  bucket = aws_s3_bucket.tfstate_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_encryption" {
  bucket = aws_s3_bucket.tfstate_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate_block" {
  bucket = aws_s3_bucket.tfstate_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "daily-finance-frontend-${var.env}"
}

resource "aws_s3_bucket_public_access_block" "frontend_block" {
  bucket = aws_s3_bucket.frontend_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontAccess"
        Effect    = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.frontend_oai.iam_arn
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.frontend_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "create_zip" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = "create.zip"
  source = data.archive_file.create_zip.output_path
  etag   = data.archive_file.create_zip.output_base64sha256
}

resource "aws_s3_object" "list_zip" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = "list.zip"
  source = data.archive_file.list_zip.output_path
  etag   = data.archive_file.list_zip.output_base64sha256
}

resource "aws_s3_object" "delete_zip" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = "delete.zip"
  source = data.archive_file.delete_zip.output_path
  etag   = data.archive_file.delete_zip.output_base64sha256
}

