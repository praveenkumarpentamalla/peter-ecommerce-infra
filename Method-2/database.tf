
resource "aws_dynamodb_table" "orders" {
  name         = "Peter-orders"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "order_id"

  attribute {
    name = "order_id"
    type = "S"
  }
}


# resource "aws_db_instance" "postgres" {
#   allocated_storage    = 20
#   engine               = "postgresql"
#   instance_class       = "db.t3.micro"
#   db_name              = "ecommerce"
#   username             = "postgres"
#   password             = aws_secretsmanager_secret_version.db_password.secret_string
#   skip_final_snapshot  = true
#   vpc_security_group_ids = [aws_security_group.rds.id]
# }