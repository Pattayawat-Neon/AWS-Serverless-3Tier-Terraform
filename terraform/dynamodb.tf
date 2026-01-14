resource "aws_dynamodb_table" "daily_finance_db" {
  name         = var.db_table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "pk"
  range_key = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  tags = {
    Name = "Daily-Finance-${var.env}"
  }
}
