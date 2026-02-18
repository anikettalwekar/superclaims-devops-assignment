### Fill Complete Journeytrigger pipeline
# DevOps Assessment – My Journey

## Step 1 – Understand the Project

First I checked the given project. It has:

- FastAPI backend
- Celery worker
- Redis
- Simple frontend
- API endpoints:
  - POST /notify/
  - GET /task_status/{task_id}

Main goal was:
Containerize → Run locally → Deploy using IaC → Use CI/CD → Use managed services.

---

## Step 2 – Run Locally Without Docker

I tested the project locally:

- Started Redis
- Started Celery worker
- Started FastAPI using uvicorn
- Opened frontend in browser

Everything was working.

---

## Step 3 – Containerization

Then I created:

- Dockerfile for backend
- Dockerfile for worker
- Used official Redis image
- Used nginx for frontend

All hardcoded values moved to environment variables.

Then I created docker-compose.yml to run:

- backend
- worker
- redis
- frontend

Command used:

docker-compose up --build

Project was running on localhost successfully.

---

## Step 4 – Cloud Architecture Design

I decided to use:

- AWS ECS Fargate (managed container service)
- Application Load Balancer (public access)
- ECR (store docker images)
- CloudWatch (logs)
- Terraform (Infrastructure as Code)
- GitHub Actions (CI/CD)

Why ECS Fargate?
Because no need to manage EC2 servers. Fully managed.

Why ALB?
To expose application publicly and handle traffic.

Why CloudWatch?
To monitor logs and debugging.

---

## Step 5 – Infrastructure using Terraform

I created Terraform files:

- VPC (public + private subnets)
- Internet Gateway
- Route tables
- Security Groups
- ALB
- Target Group
- ECS Cluster
- ECS Task Definition
- ECS Service
- ECR Repository
- CloudWatch log group

Applied using:

terraform init  
terraform plan  
terraform apply  

Infrastructure was created successfully.

---

## Step 6 – CI/CD Setup

Created GitHub Actions workflow.

Pipeline steps:

1. Build Docker image
2. Login to ECR
3. Push image to ECR
4. Update ECS service

Added AWS secrets in GitHub:

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY

After push → pipeline deployed automatically.

---

## Step 7 – Problems Faced

1. Terraform provider binaries pushed to GitHub (large file error)
   - Fixed using .gitignore and clean git re-init.

2. ElastiCache issue
   - Finally used Redis container inside ECS task.

3. CloudWatch logging missing initially
   - Added awslogs configuration in task definition.

4. ALB health check path issue
   - Fixed using /health endpoint.

---

## Final Result

Application successfully deployed on:

ALB URL:
http://superclaims-alb-xxxxx.ap-south-1.elb.amazonaws.com

Features working:

- Trigger task
- Check task status
- Logs visible in CloudWatch
- CI/CD auto deploy
- Terraform fully managing infra

Project completed successfully.
