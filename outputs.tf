output "load_balancer_dns" {
  description = "The public URL for your Strapi application"
  value       = module.alb.alb_dns_name
}

output "rds_endpoint" {
  description = "The connection endpoint for your database"
  # Change db_endpoint to db_instance_endpoint
  value       = module.rds.db_instance_endpoint
}

output "ecs_cluster_name" {
  description = "The name of your ECS cluster"
  value       = module.ecs.cluster_name
}