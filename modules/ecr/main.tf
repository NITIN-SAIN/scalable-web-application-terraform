resource "aws_ecr_repository" "app" {
  name                 = "scalable-web-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = " scalable-web-app-ecr"
    Environment = "dev"
  }
}