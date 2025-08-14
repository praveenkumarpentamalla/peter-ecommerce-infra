output "frontend_url" {
  description = "URL of the frontend application"
  value       = module.amplify.app_url
}

output "backend_url" {
  description = "URL of the backend API"
  value       = module.ecs.alb_dns_name
}

output "ecr_repository_url" {
  description = "URL of the ECR repository for backend images"
  value       = module.ecs.ecr_repository_url
}

output "github_actions_access_key" {
  description = "AWS access key for GitHub Actions"
  value       = module.ci_cd.aws_access_key_id
  sensitive   = true
}

output "github_actions_secret_key" {
  description = "AWS secret key for GitHub Actions"
  value       = module.ci_cd.aws_secret_access_key
  sensitive   = true
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = module.dynamodb.table_name
}