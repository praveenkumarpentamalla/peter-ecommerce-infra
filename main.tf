provider "aws" {
  region = var.aws_region
}

module "amplify" {
  source     = "./amplify"
  repository = var.frontend_repo
  env        = var.env
}

module "dynamodb" {
  source = "./dynamodb"
  env    = var.env
}

module "ecs" {
  source              = "./ecs"
  env                 = var.env
  github_repo         = var.backend_repo
  ecs_task_cpu        = var.ecs_task_cpu
  ecs_task_memory     = var.ecs_task_memory
  desired_task_count  = var.desired_task_count
  dynamodb_table_name = module.dynamodb.table_name
}

module "ci_cd" {
  source         = "./ci-cd"
  github_token   = var.github_token
  env            = var.env
  ecs_cluster    = module.ecs.cluster_name
  ecs_service    = module.ecs.service_name
  repository_url = module.ecs.ecr_repository_url
  aws_region     = var.aws_region
}
