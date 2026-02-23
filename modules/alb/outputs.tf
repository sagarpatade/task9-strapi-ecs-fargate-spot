# modules/alb/outputs.tf

output "target_group_arn" {
  description = "The ARN of the Target Group (needed by ECS)"
  value       = aws_lb_target_group.strapi_tg.arn
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  # Change from strapi_alb to main
  value       = aws_lb.main.dns_name 
}