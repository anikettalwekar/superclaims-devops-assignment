resource "aws_ecr_repository" "app_repo" {
  name = "${var.project_name}-repo"

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"

  tags = {
    Name = "${var.project_name}-ecr"
  }
}
