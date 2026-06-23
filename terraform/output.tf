output "alb_dns_name" {
  value = aws_lb.weather_alb.dns_name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.weather_repo.repository_url
}