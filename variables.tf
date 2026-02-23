variable "aws_region" {
  description = "The AWS region to deploy all resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "Your 12-digit AWS Account ID (needed for IAM roles)"
  type        = string
}

variable "vpc_id" {
  description = "The existing VPC ID provided by your organization"
  type        = string
  default     = "vpc-091cb9c5df7bd2971"
}

variable "db_password" {
  description = "Password for the PostgreSQL database"
  type        = string
  sensitive   = true
  default     = "strapi12345"
}

variable "db_username" {
  description = "Username for the PostgreSQL database"
  type        = string
  default     = "postgres"
}

variable "private_subnets" {
  description = "List of private subnet IDs for the ECS tasks"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "Security group ID for the ECS service"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}

variable "db_host" {
  description = "The endpoint/address of the RDS database"
  type        = string
}