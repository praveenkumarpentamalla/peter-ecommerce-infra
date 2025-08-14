resource "aws_ecr_repository" "backend" {
  name = "Peter-backend"
}

resource "aws_iam_user" "github_actions" {
  name = "github-actions-deployer"
}

resource "aws_iam_user_policy_attachment" "ecr_push" {
  user       = aws_iam_user.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}