# SuperClaims DevOps Assignment

Hi,

This is my DevOps assignment project. In this project I containerized the application and deployed it on AWS using ECS Fargate. I also implemented CI/CD pipeline using GitHub Actions.

## Project Overview

This project has:

- FastAPI backend
- Celery worker
- Redis as message broker
- Simple frontend
- Docker setup
- Terraform infrastructure
- GitHub Actions CI/CD

User flow:

User → ALB → ECS Fargate → Backend → Redis → Worker

## Architecture

The architecture includes:

- Custom VPC (ap-south-1)
- 2 Public Subnets
- 2 Private Subnets
- Internet Gateway
- Application Load Balancer (Internet-facing)
- ECS Cluster (Fargate)
- ECR Repository
- CloudWatch Logs
- GitHub Actions for CI/CD

Architecture diagram is attached below.
https://github.com/anikettalwekar/superclaims-devops-assignment/blob/main/architecture/project%20architecture.png

## Infrastructure (Terraform)

All AWS resources are created using Terraform.

Main resources:

- VPC
- Subnets
- Route tables
- Security Groups
- ALB
- Target Group
- ECS Cluster
- ECS Service
- ECR Repository
- CloudWatch Log Group

Commands used:

terraform init  
terraform plan  
terraform apply  

No manual creation from console.

## CI/CD Pipeline

I created GitHub Actions workflow.

Pipeline steps:

1. Build Docker image
2. Login to Amazon ECR
3. Push image to ECR
4. Force new ECS deployment

Whenever I push code to main branch, deployment happens automatically.

## CloudWatch Logs

Container logs are sent to CloudWatch log group:

/ecs/superclaims

This helps in debugging and monitoring.

## Application URL

Application is accessible through ALB DNS.

Health endpoint:

/health

## Run Locally

To run project locally:

docker-compose up --build

Frontend:
http://localhost:3000

Backend:
http://localhost:8000

## Screenshots

All deployment screenshots are available in screenshots folder.

## Challenges Faced

- Terraform provider files accidentally pushed to GitHub (large file issue). Fixed using .gitignore and clean git re-initialization.
- ElastiCache creation issue, so Redis container is used inside ECS task.
- ALB health check path needed proper endpoint.

## Conclusion

This project demonstrates containerization, Infrastructure as Code, CI/CD automation and cloud deployment using AWS ECS Fargate.

Thank you.
