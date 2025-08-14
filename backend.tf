terraform {
  backend "s3" {
    bucket         = "peter-ecommerce-tfstate" 
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock" 
  }
}