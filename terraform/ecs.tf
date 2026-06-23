resource "aws_ecs_cluster" "weather_cluster" {
  name = "weather-cluster"
}

resource "aws_ecs_task_definition" "weather_task" {

  family                   = "weather-task"
  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"

  cpu    = 256
  memory = 512

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name = "weather-app"

      image = "343218226443.dkr.ecr.us-east-1.amazonaws.com/weather-app:latest"

      essential = true

      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "weather_service" {

  name    = "weather-service"
  cluster = aws_ecs_cluster.weather_cluster.id

  task_definition = aws_ecs_task_definition.weather_task.arn

  desired_count = 2

  launch_type = "FARGATE"

  network_configuration {

    subnets = [
      aws_subnet.public1.id,
      aws_subnet.public2.id
    ]

    security_groups = [
      aws_security_group.ecs_sg.id
    ]

    assign_public_ip = true
  }

  load_balancer {

    target_group_arn = aws_lb_target_group.weather_tg.arn

    container_name = "weather-app"

    container_port = 5000
  }

  depends_on = [
    aws_lb_listener.listener
  ]
}