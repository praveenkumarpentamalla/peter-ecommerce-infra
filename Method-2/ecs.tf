resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-cluster"
}

resource "aws_ecs_task_definition" "backend" {
  family                   = "Peter-backend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name  = "Peter-backend",
    image = "${aws_ecr_repository.backend.repository_url}:latest",
    portMappings = [{ containerPort = 8080 }]
  }])
}

resource "aws_ecs_service" "backend" {
  name            = "Peter-backend-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets          = aws_subnet.private.*.id
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = false
  }
}