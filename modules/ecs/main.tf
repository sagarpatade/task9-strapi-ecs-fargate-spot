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
# 1. This is your Task Definition 
# 2. THE TASK DEFINITION (Named "strapi")
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


