variable "env" {
  description = "Deployment environment"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository URL for the backend"
  type        = string
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

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}