output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.backend.name
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.backend.name
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.backend.repository_url
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.backend.dns_name
}

output "task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.backend.arn
}