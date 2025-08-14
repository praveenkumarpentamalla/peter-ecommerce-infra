output "aws_access_key_id" {
  description = "AWS access key ID for GitHub Actions"
  value       = aws_iam_access_key.github_actions.id
  sensitive   = true
}

output "aws_secret_access_key" {
  description = "AWS secret access key for GitHub Actions"
  value       = aws_iam_access_key.github_actions.secret
  sensitive   = true
}

output "iam_user_name" {
  description = "Name of the IAM user for GitHub Actions"
  value       = aws_iam_user.github_actions.name
}