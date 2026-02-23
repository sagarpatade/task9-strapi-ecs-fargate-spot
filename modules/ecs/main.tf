# 1. Cluster Definition
resource "aws_ecs_cluster" "main" {
  name = "sagar-strapi-cluster"
}

# 2. Task Definition (Named "strapi")
resource "aws_ecs_task_definition" "strapi" {
  family                   = "strapi-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/strapi-repo:latest"
      essential = true
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/strapi"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
          "awslogs-create-group"  = "true"
        }
      }
    }
  ])
}

# 3. ECS Service (References "strapi")
resource "aws_ecs_service" "main" {
  name            = "sagar-strapi-service"
  cluster         = aws_ecs_cluster.main.id
  
  # FIX: This was calling .app.arn, now it calls .strapi.arn
  task_definition = aws_ecs_task_definition.strapi.arn
  
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "strapi"
    container_port   = 1337
  }
}

# 4. Output the Cluster Name
output "cluster_name" {
  value = aws_ecs_cluster.main.name
}