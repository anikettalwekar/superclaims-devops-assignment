resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = "/ecs/superclaims"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

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

resource "aws_ecs_cluster" "main" {
  name = "superclaims-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "superclaims-app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "redis"
      image = "redis:7"
      essential = true
      portMappings = [{
        containerPort = 6379
      }]
    },
    {
      name  = "backend"
      image = "${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/superclaims-devops-repo:latest"
      essential = true
      portMappings = [{
        containerPort = 8000
      }]
      environment = [
        {
          name  = "REDIS_URL"
          value = "redis://localhost:6379/0"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "backend"
        }
      }
    },
    {
      name  = "worker"
      image = "${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/superclaims-devops-repo:latest"
      essential = false
      command = ["celery", "-A", "worker", "worker", "--loglevel=info"]
      environment = [
        {
          name  = "REDIS_URL"
          value = "redis://localhost:6379/0"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = "superclaims-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.private_a.id, aws_subnet.private_b.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "backend"
    container_port   = 8000
  }

  depends_on = [aws_lb_listener.http]
}
