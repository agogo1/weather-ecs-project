resource "aws_ecr_repository" "weather_repo" {

  name = "weather-app"

  image_scanning_configuration {
    scan_on_push = true
  }
}