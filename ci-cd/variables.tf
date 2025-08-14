variable "env" {
  description = "Deployment environment"
  type        = string
}

variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "ecs_cluster" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "ecs_service" {
  description = "Name of the ECS service"
  type        = string
}

variable "repository_url" {
  description = "ECR repository URL"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}