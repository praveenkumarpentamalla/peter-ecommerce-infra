
resource "aws_ecr_repository" "backend" {
  name = "peter-backend-${var.env}"
}


resource "aws_ecs_cluster" "backend" {
  name = "peter-backend-${var.env}"
}


resource "aws_ecs_task_definition" "backend" {
  family                   = "peter-backend-${var.env}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([{
    name      = "backend"
    image     = "${aws_ecr_repository.backend.repository_url}:latest"
    cpu       = var.ecs_task_cpu
    memory    = var.ecs_task_memory
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
    environment = [
      { name = "ENVIRONMENT", value = var.env },
      { name = "DYNAMODB_TABLE", value = var.dynamodb_table_name }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/peter-backend-${var.env}"
        "awslogs-region"       = var.aws_region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}


resource "aws_ecs_service" "backend" {
  name            = "peter-backend-${var.env}"
  cluster         = aws_ecs_cluster.backend.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = var.desired_task_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.private.*.id
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = "backend"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.backend]
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = "peter-ecs-task-execution-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "peter-ecs-task-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "dynamodb_access" {
  name        = "peter-dynamodb-access-${var.env}"
  description = "Policy for accessing DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:BatchGetItem",
        "dynamodb:BatchWriteItem"
      ]
      Resource = [
        "arn:aws:dynamodb:${var.aws_region}:*:table/${var.dynamodb_table_name}",
        "arn:aws:dynamodb:${var.aws_region}:*:table/${var.dynamodb_table_name}/index/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_dynamodb" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}


resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = "${var.aws_region}${count.index == 0 ? "a" : "b"}"
}

resource "aws_security_group" "ecs" {
  name        = "peter-ecs-${var.env}"
  description = "Allow inbound access to ECS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_lb" "backend" {
  name               = "peter-backend-${var.env}"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_target_group" "backend" {
  name        = "peter-backend-${var.env}"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.backend.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}

output "cluster_name" {
  value = aws_ecs_cluster.backend.name
}

output "service_name" {
  value = aws_ecs_service.backend.name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "alb_dns_name" {
  value = aws_lb.backend.dns_name
}