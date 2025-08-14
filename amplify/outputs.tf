output "app_url" {
  description = "URL of the Amplify application"
  value       = "https://main.${aws_amplify_app.frontend.default_domain}"
}

output "app_id" {
  description = "ID of the Amplify application"
  value       = aws_amplify_app.frontend.id
}

output "branch_name" {
  description = "Name of the main branch"
  value       = aws_amplify_branch.main.branch_name
}