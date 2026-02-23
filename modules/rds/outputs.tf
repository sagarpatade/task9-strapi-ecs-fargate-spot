output "db_instance_endpoint" {
  description = "The database URL/address to pass to the Strapi containers"
  # Use .address or .endpoint (endpoint includes the port)
  value       = aws_db_instance.strapi_db.address
}