resource "aws_amplify_app" "frontend" {
  name       = "peter-frontend-${var.env}"
  repository = var.repository
  platform   = "WEB"

 
  enable_basic_auth = true
  basic_auth_credentials = base64encode("peter:griffin")

  
  enable_branch_auto_build = true  

  
  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - npm ci
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  
  environment_variables = {
    ENV = var.env
    REACT_APP_API_URL = "http://${module.ecs.alb_dns_name}"
  }

 
  production_branch = "main"
  auto_branch_creation_config {
    enable_auto_build = true 
    enable_pull_request_preview = false
  }
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.frontend.id
  branch_name = "main"

  
  enable_auto_build = true

  framework = "React"
  stage     = "PRODUCTION"

  environment_variables = {
    REACT_APP_STAGE = "production"
  }
}

output "app_url" {
  value = "https://main.${aws_amplify_app.frontend.default_domain}"
}









# resource "aws_amplify_app" "frontend" {
#   name       = "peter-frontend-${var.env}"
#   repository = var.repository
#   platform   = "WEB"

  
#   enable_basic_auth = true
#   basic_auth_credentials = base64encode("peter:griffin")


#   enable_auto_branch_creation = false
#   enable_branch_auto_build   = true

#   environment_variables = {
#     ENV = var.env
#   }

#   production_branch = "main"
# }

# resource "aws_amplify_branch" "main" {
#   app_id      = aws_amplify_app.frontend.id
#   branch_name = "main"

 
#   enable_auto_build = true

  
#   framework = "React"
#   stage     = "PRODUCTION"
# }

# output "app_url" {
#   value = "https://main.${aws_amplify_app.frontend.default_domain}"
# }