# How to Run Project Locally (Containerized Setup)

## Prerequisites

Make sure you have:

- Docker installed
- Docker Compose installed

Check:

docker --version
docker-compose --version

---

## Step 1 – Clone Repository

git clone <your-repo-url>
cd superclaims-devops-assignment

---

## Step 2 – Build and Start Containers

Run:

docker-compose up --build

This will start:

- backend (FastAPI)
- worker (Celery)
- redis
- frontend (nginx)

---

## Step 3 – Access Application

Frontend:

http://localhost:3000

Backend:

http://localhost:8000

Health check:

http://localhost:8000/health

---

## Step 4 – Stop Containers

Press CTRL + C  
Or run:

docker-compose down

---

## Debugging

View running containers:

docker ps

View logs:

docker-compose logs backend
docker-compose logs worker
docker-compose logs redis

Rebuild again if needed:

docker-compose up --build

---

Project is fully containerized and runs locally using Docker Compose.
