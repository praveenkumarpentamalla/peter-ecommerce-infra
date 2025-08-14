variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "frontend_repo" {
  description = "Frontend GitHub repository URL"
  type        = string
  default     = "https://github.com/praveenkumarpentamalla/peter-frontend.git"
}

variable "backend_repo" {
  description = "Backend GitHub repository URL"
  type        = string
  default     = "https://github.com/praveenkumarpentamalla/peter-backend.git"
}

variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "ecs_task_cpu" {
  description = "ECS task CPU units"
  type        = number
  default     = 256
}

variable "ecs_task_memory" {
  description = "ECS task memory in MB"
  type        = number
  default     = 512
}

variable "desired_task_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 1
}