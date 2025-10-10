# Outputs do Terraform
output "images_bucket_name" {
  description = "Nome do bucket S3 para imagens"
  value       = aws_s3_bucket.images.bucket
}

output "images_bucket_arn" {
  description = "ARN do bucket S3 para imagens"
  value       = aws_s3_bucket.images.arn
}

output "frontend_bucket_name" {
  description = "Nome do bucket S3 para frontend"
  value       = aws_s3_bucket.frontend.bucket
}

output "frontend_bucket_arn" {
  description = "ARN do bucket S3 para frontend"
  value       = aws_s3_bucket.frontend.arn
}

output "frontend_website_endpoint" {
  description = "Endpoint do website estático"
  value       = aws_s3_bucket_website_configuration.frontend_website.website_endpoint
}

output "environment" {
  description = "Ambiente atual"
  value       = var.env
}

output "aws_region" {
  description = "Região AWS utilizada"
  value       = var.region
}

output "app_runner_url" {
  description = "URL pública do App Runner (API)"
  value       = try(aws_apprunner_service.achados_api_service.service_url, "")
}