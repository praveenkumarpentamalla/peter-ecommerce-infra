output "amplify_app_url" {
  value = aws_amplify_app.frontend.default_domain
}

output "ecr_repository_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "backend_endpoint" {
  value = "http://${aws_ecs_service.backend.name}.internal:8080"
}