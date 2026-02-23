output "cluster_name" {
  # Changed from 'strapi_cluster' to 'main' to match your main.tf
  value = aws_ecs_cluster.main.name
}

output "service_name" {
  # Changed from 'strapi_service' to 'main' to match your main.tf
  value = aws_ecs_service.main.name
}