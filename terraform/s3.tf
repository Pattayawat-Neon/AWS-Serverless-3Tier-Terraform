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

