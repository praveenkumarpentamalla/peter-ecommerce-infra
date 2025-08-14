resource "aws_dynamodb_table" "ecommerce" {
  name         = "peter-ecommerce-${var.env}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PK"
  range_key    = "SK"

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }

 
  global_secondary_index {
    name            = "GSI1"
    hash_key        = "SK"
    range_key       = "PK"
    projection_type = "ALL"
  }

  tags = {
    Environment = var.env
    Name        = "Peter's E-Commerce"
  }
}

output "table_name" {
  value = aws_dynamodb_table.ecommerce.name
}