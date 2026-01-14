
data "archive_file" "create_zip" {
  type        = "zip"
  source_file = "../backend/createTransaction.py"
  output_path = "create.zip"
}

data "archive_file" "list_zip" {
  type        = "zip"
  source_file = "../backend/listTransactions.py"
  output_path = "list.zip"
}

resource "aws_lambda_function" "create_transaction" {
  function_name = "create-transaction-${var.env}"
  runtime       = "python3.9"
  handler       = "createTransaction.handler"
  role          = aws_iam_role.lambda_role.arn

  s3_bucket         = aws_s3_bucket.lambda_bucket.bucket
  s3_key            = aws_s3_object.create_zip.key
  s3_object_version = aws_s3_object.create_zip.version_id

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.daily_finance_db.name
    }
  }
}

resource "aws_lambda_function" "list_transactions" {
  function_name = "list-transactions-${var.env}"
  runtime       = "python3.9"
  handler       = "listTransactions.handler"
  role          = aws_iam_role.lambda_role.arn

  s3_bucket         = aws_s3_bucket.lambda_bucket.bucket
  s3_key            = aws_s3_object.list_zip.key
  s3_object_version = aws_s3_object.list_zip.version_id

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.daily_finance_db.name
    }
  }
}

data "archive_file" "delete_zip" {
  type        = "zip"
  source_file = "../backend/deleteTransaction.py"
  output_path = "delete.zip"
}

resource "aws_lambda_function" "delete_transaction" {
  function_name = "delete-transaction-${var.env}"
  runtime       = "python3.9"
  handler       = "deleteTransaction.handler"
  role          = aws_iam_role.lambda_role.arn

  s3_bucket         = aws_s3_bucket.lambda_bucket.bucket
  s3_key            = aws_s3_object.delete_zip.key
  s3_object_version = aws_s3_object.delete_zip.version_id

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.daily_finance_db.name
    }
  }
}

