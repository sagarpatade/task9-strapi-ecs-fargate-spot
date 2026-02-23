# 1. The Cluster
resource "aws_ecs_cluster" "main" {
  name = "sagar-strapi-cluster"
}

# 2. Capacity Provider Strategy for the Cluster
# This tells the cluster to allow FARGATE_SPOT
resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name       = aws_ecs_cluster.main.name
  capacity_providers = ["FARGATE_SPOT"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }
}

# 3. The Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = "strapi-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  # Use ${var.aws_account_id} to inject your real ID automatically
  execution_role_arn = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"
  task_role_arn      = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"
  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = "your-ecr-repo-url:latest" # This will be injected by the CI/CD
      essential = true
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
        }
      ]
      environment = [
        { name = "DATABASE_HOST", value = var.db_host },
        { name = "DATABASE_PORT", value = "5432" },
        { name = "DATABASE_NAME", value = "strapi" },
        { name = "DATABASE_USERNAME", value = "postgres" },
        { name = "DATABASE_PASSWORD", value = "strapi12345" },
        { name = "NODE_ENV", value = "production" }
      ]
      # NOTE: logConfiguration block is REMOVED to disable CloudWatch logging
    }
  ])
}

# 4. The Service (Configured for Spot)
resource "aws_ecs_service" "main" {
  name            = "sagar-strapi-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1

  # This forces the service to use the cheaper Spot instances
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
    base              = 0
  }

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false # Hidden in the private network
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "strapi"
    container_port   = 1337
  }

  # This helps avoid errors when redeploying
  force_new_deployment = true
}


