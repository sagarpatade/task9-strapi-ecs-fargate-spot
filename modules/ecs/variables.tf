variable "target_group_arn" {
  description = "The ARN of the Load Balancer Target Group"
  type        = string
}

variable "private_subnets" {
  description = "A list of private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "The security group ID for the ECS service"
  type        = string
}

variable "db_host" {
  description = "The database endpoint URL"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS Account ID"
  type        = string
}

