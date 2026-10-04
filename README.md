# Docker Learning Roadmap

> A practical journey to learn Docker from zero to production.

![Docker](https://img.shields.io/badge/Docker-Learning-2496ED?logo=docker&logoColor=white)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-4.x-6DB33F?logo=springboot&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?logo=mysql&logoColor=white)

## About

This repository is my personal Docker learning laboratory.

The goal is not only to memorize Docker commands, but to understand how Docker is used to build, run, connect, persist, deploy, and monitor real-world applications.

The repository starts with a simple Spring Boot + MySQL application and gradually expands to Redis, Nginx, Kafka, CI/CD, production deployment, and Kubernetes.

## Docker Architecture

![Docker Architecture](docs/docker-architecture.png)

> This diagram summarizes the relationship between the Dockerfile, Docker CLI, Docker Daemon, images, containers, Docker Compose, networks, and image registries.

```text
Application
    ↓
Dockerfile
    ↓
Docker Image
    ↓
Docker Container
    ↓
Port Mapping
    ↓
Network
    ↓
Volume
    ↓
Docker Compose
    ↓
Multi-container Application
    ↓
Redis / Nginx / Kafka
    ↓
CI/CD
    ↓
Docker Registry
    ↓
Production
    ↓
Kubernetes
```

---

# Roadmap

## Phase 1 — Docker Fundamentals

- [ ] What is Docker?
- [ ] Docker Engine
- [ ] Docker Desktop
- [ ] Docker CLI
- [ ] Image vs Container
- [ ] Dockerfile
- [ ] Docker Registry
- [ ] Docker Hub
- [ ] Docker Compose

### Essential commands

```bash
docker --version
docker version
docker info
docker help
docker ps
docker ps -a
docker images
docker pull <image>
docker build -t <image> .
docker run <image>
docker start <container>
docker stop <container>
docker restart <container>
docker rm <container>
docker rmi <image>
docker logs <container>
docker exec -it <container> bash
docker inspect <container>
docker stats
```

---

## Phase 2 — Dockerfile

Learn:

```text
FROM
WORKDIR
COPY
ADD
RUN
CMD
ENTRYPOINT
EXPOSE
ENV
ARG
USER
VOLUME
HEALTHCHECK
```

Example:

```dockerfile
FROM eclipse-temurin:21-jdk

WORKDIR /app

COPY target/app.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
```

Understand:

- Base images
- Build context
- Image layers
- Build cache
- `.dockerignore`
- `CMD` vs `ENTRYPOINT`
- Environment variables

---

## Phase 3 — Images and Containers

Understand the core relationship:

```text
Dockerfile
    ↓ docker build
Image
    ↓ docker run
Container
```

Practice:

```bash
docker build -t my-app .
docker images
docker run -d --name my-app my-app
docker ps
docker logs my-app
docker stop my-app
docker rm my-app
```

Learn the container lifecycle:

```text
Created → Running → Stopped → Removed
```

---

## Phase 4 — Ports and Networking

Learn port mapping:

```text
HOST:CONTAINER
```

Example:

```yaml
ports:
  - "8080:8080"
```

Meaning:

```text
localhost:8080
      ↓
container:8080
      ↓
Spring Boot
```

### Docker networking

```bash
docker network ls
docker network create <network>
docker network inspect <network>
docker network connect <network> <container>
docker network disconnect <network> <container>
```

Understand:

- Bridge networks
- Container-to-container communication
- DNS/service names
- `localhost` inside a container
- Host ports vs container ports

---

## Phase 5 — Volumes and Persistent Data

Learn:

```bash
docker volume ls
docker volume create <volume>
docker volume inspect <volume>
docker volume rm <volume>
```

Understand:

```text
Container filesystem
        ↓
     Volume
        ↓
Persistent data
```

Also learn:

- Named volumes
- Bind mounts
- Temporary storage
- Database persistence

---

## Phase 6 — Environment Variables

Learn:

```bash
docker run -e MYSQL_DATABASE=testdb <image>
```

Compose example:

```yaml
environment:
  MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
  MYSQL_DATABASE: ${MYSQL_DATABASE}
```

Practice with `.env` and learn why passwords and environment-specific configuration should not be hard-coded.

---

## Phase 7 — Docker Compose

Learn:

```bash
docker compose up
docker compose up -d
docker compose up -d --build
docker compose down
docker compose ps
docker compose logs
docker compose logs -f
docker compose build
docker compose pull
docker compose restart
docker compose start
docker compose stop
```

Understand:

- `services`
- `build`
- `image`
- `ports`
- `environment`
- `volumes`
- `networks`
- `depends_on`
- Health checks

---

## Phase 8 — Spring Boot + MySQL

Current project foundation:

```text
Docker Compose
│
├── Spring Boot
│      │
│      └── MySQL
│
└── Persistent Volume
```

Example:

```yaml
services:
  app:
    build: .
    ports:
      - "8080:8080"
    depends_on:
      - mysql

  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: 123456
      MYSQL_DATABASE: testdb
    ports:
      - "3307:3306"
    volumes:
      - mysql-data:/var/lib/mysql

volumes:
  mysql-data:
```

Important concept:

```text
Spring Boot → mysql:3306
```

Inside Compose, the application communicates with MySQL through the service name `mysql`, not `localhost`.

---

## Phase 9 — Databases and Infrastructure

Practice Docker with:

- [ ] MySQL
- [ ] PostgreSQL
- [ ] MongoDB
- [ ] Redis
- [ ] Elasticsearch

Learn:

- Persistent volumes
- Initialization scripts
- Database backups
- Database networking
- Health checks

---

## Phase 10 — Other Programming Languages

Dockerize applications built with:

### Java

- Spring Boot
- Maven
- Gradle

### JavaScript / TypeScript

- Node.js
- Express
- NestJS
- Next.js

### Python

- FastAPI
- Flask
- Django

### Go

- Go
- Gin
- Fiber

The fundamental process remains:

```text
Source Code
    ↓
Dockerfile
    ↓
Image
    ↓
Container
```

---

## Phase 11 — Multi-stage Builds

Learn how to separate build and runtime environments.

Example:

```dockerfile
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
CMD ["java", "-jar", "app.jar"]
```

Goals:

- Smaller images
- Better security
- Faster deployments
- Separate build and runtime dependencies

---

## Phase 12 — Image Optimization

Learn:

- Small base images
- JRE vs JDK
- Alpine images
- Distroless images
- Multi-stage builds
- Layer optimization
- Build cache
- `.dockerignore`

Useful commands:

```bash
docker images
docker history <image>
docker image inspect <image>
```

---

## Phase 13 — Docker Security

Learn:

- Run containers as non-root
- Minimal images
- Secrets management
- Vulnerability scanning
- Read-only filesystems
- Resource limits
- Safe environment configuration
- Image provenance

Avoid:

```yaml
environment:
  MYSQL_PASSWORD: real-password
```

Prefer environment-specific secrets/configuration.

---

## Phase 14 — Health Checks

Understand the difference between:

```text
Container started
```

and:

```text
Application ready
```

Example:

```yaml
healthcheck:
  test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
  interval: 10s
  timeout: 5s
  retries: 5
```

Learn application readiness, service dependencies, restart policies, and failure handling.

---

## Phase 15 — Advanced Docker Compose

Learn:

- Multiple Compose files
- Development vs production Compose
- Profiles
- Custom networks
- Named volumes
- Health checks
- Secrets
- Configs
- Resource limits
- Restart policies

Example structure:

```text
compose.yml
compose.dev.yml
compose.prod.yml
```

---

## Phase 16 — Nginx and Reverse Proxy

Architecture:

```text
Internet
   ↓
Nginx
   ↓
Spring Boot
   ↓
MySQL
```

Learn:

- Reverse proxy
- Routing
- Load balancing
- Static files
- HTTPS
- SSL certificates

---

## Phase 17 — Redis

Architecture:

```text
Spring Boot
 ├── MySQL
 └── Redis
```

Learn:

- Cache
- TTL
- Sessions
- Redis networking
- Persistent Redis data

---

## Phase 18 — Message Brokers

### RabbitMQ

```text
Backend
   ↓
RabbitMQ
   ↓
Worker
```

### Kafka

```text
Producer
   ↓
Kafka
   ↓
Consumer
```

Learn:

- Producer
- Consumer
- Queue
- Topic
- Broker
- Async processing
- Persistent messaging

---

## Phase 19 — Microservices

Build a Dockerized microservice system:

```text
                  API Gateway
                       │
          ┌────────────┼────────────┐
          ↓            ↓            ↓
       User         Product       Order
       Service      Service       Service
          │            │            │
          ↓            ↓            ↓
        MySQL       PostgreSQL     MySQL
```

Learn:

- Service isolation
- Service-to-service communication
- Database per service
- Internal networks
- API Gateway
- Async communication

---

## Phase 20 — Docker Registry

Learn:

```bash
docker login
docker tag <image> <repository>:<tag>
docker push <repository>:<tag>
docker pull <repository>:<tag>
```

Practice with:

- Docker Hub
- GitHub Container Registry

Architecture:

```text
Local Image
    ↓
Container Registry
    ↓
Server
    ↓
docker pull
    ↓
Container
```

---

## Phase 21 — CI/CD

Build a Docker CI/CD pipeline:

```text
git push
   ↓
GitHub Actions
   ↓
Tests
   ↓
Docker Build
   ↓
Security Scan
   ↓
Push Image
   ↓
Deploy
```

Learn:

- GitHub Actions
- Docker Buildx
- Container Registry
- Automated tests
- Automated deployment

---

## Phase 22 — Docker Buildx

Learn:

```bash
docker buildx ls
docker buildx build
```

Understand:

- Advanced builds
- Build cache
- Multi-platform images
- AMD64
- ARM64

---

## Phase 23 — Linux Server Deployment

Deploy Docker applications to a VPS:

```text
Internet
   ↓
Linux Server
   ↓
Docker
   ├── Nginx
   ├── Backend
   ├── Database
   └── Redis
```

Learn:

- Linux basics
- SSH
- Docker Engine
- Firewall
- Ports
- Volumes
- Logs
- Restart policies
- Server configuration

---

## Phase 24 — Production Docker

Learn:

- Health checks
- Restart policies
- Resource limits
- Logging
- Monitoring
- Backups
- Secrets
- Image versioning
- HTTPS
- Reverse proxy
- Zero-downtime deployment

Production architecture:

```text
Internet
    ↓
  Nginx
    ↓
┌───────────┐
│ Backend 1 │
│ Backend 2 │
└───────────┘
    ↓
 Redis / DB
```

---

## Phase 25 — Monitoring

Explore:

- Prometheus
- Grafana
- cAdvisor
- Loki
- Promtail

Architecture:

```text
Containers
    ↓
cAdvisor
    ↓
Prometheus
    ↓
Grafana
```

Monitor:

- CPU
- RAM
- Network
- Disk
- Container health
- Application metrics

---

## Phase 26 — Centralized Logging

Start with:

```bash
docker logs <container>
docker compose logs
```

Then explore:

```text
Containers
    ↓
Log Collector
    ↓
Loki
    ↓
Grafana
```

---

## Phase 27 — Kubernetes

After becoming comfortable with Docker and Compose, move to Kubernetes.

```text
Docker
   ↓
Container
   ↓
Kubernetes
   ↓
Pod
   ↓
Deployment
   ↓
Service
   ↓
Ingress
```

Learn:

- Kubernetes architecture
- Pod
- Deployment
- ReplicaSet
- Service
- ConfigMap
- Secret
- Volume
- PersistentVolume
- PersistentVolumeClaim
- Ingress
- Health probes
- Namespace
- Horizontal Pod Autoscaler

---

## Phase 28 — Docker Swarm

Explore Docker's native orchestration platform.

Learn:

- Swarm manager
- Worker nodes
- Services
- Stacks
- Overlay networks
- Scaling
- Rolling updates

---

## Phase 29 — Cloud Containers

Extend Docker to cloud platforms.

### AWS

- ECR
- ECS
- Fargate
- EC2
- EKS

### Google Cloud

- Artifact Registry
- Cloud Run
- GKE

### Azure

- Azure Container Registry
- Container Apps
- AKS

General flow:

```text
Docker Image
     ↓
Container Registry
     ↓
Cloud Platform
     ↓
Production
```

---

# Practical Projects

## Project 01 — Hello Docker

```text
Nginx
```

Learn:

- Image
- Container
- Port
- Logs
- Exec

---

## Project 02 — Spring Boot Container

```text
Spring Boot
```

Learn:

- Dockerfile
- Build
- Image
- Container
- Port mapping

---

## Project 03 — Spring Boot + MySQL

```text
Spring Boot
     ↓
MySQL
```

Learn:

- Docker Compose
- Network
- Volume
- Environment variables

---

## Project 04 — Spring Boot + MySQL + Redis

```text
Spring Boot
 ├── MySQL
 └── Redis
```

Learn:

- Multiple services
- Cache
- Networking
- Persistent storage

---

## Project 05 — Full Stack

```text
React
  ↓
Nginx
  ↓
Spring Boot
  ↓
MySQL
```

Learn:

- Frontend containers
- Backend containers
- Reverse proxy
- Multi-stage builds

---

## Project 06 — Event-driven System

```text
Spring Boot
    ↓
  Kafka
    ↓
 Worker
    ↓
 MySQL
```

Learn:

- Message broker
- Producer
- Consumer
- Async processing

---

## Project 07 — Microservices

```text
API Gateway
     │
 ┌───┼───────────┐
 ↓   ↓           ↓
User Product   Order
 │     │          │
DB    DB         DB
```

Learn:

- Microservices
- Service communication
- Independent containers
- Multiple databases

---

## Project 08 — Production Deployment

```text
GitHub
   ↓
GitHub Actions
   ↓
Docker Build
   ↓
Container Registry
   ↓
Cloud/VPS
   ↓
Docker
   ↓
Nginx
   ↓
Application
```

Learn:

- CI/CD
- Registry
- Linux
- VPS
- HTTPS
- Monitoring
- Production deployment

---

# Current Progress

## Docker Fundamentals

- [x] Create Dockerfile
- [x] Build Docker image
- [x] Create container
- [x] Run container
- [x] Stop/remove container
- [x] View images
- [x] View containers
- [x] Map ports

## Docker Compose

- [x] Create `docker-compose.yml`
- [x] Define services
- [x] Build application service
- [x] Use MySQL image
- [x] Configure environment variables
- [x] Configure ports
- [x] Configure volume
- [x] Use `depends_on`
- [x] Run multiple containers

## Spring Boot + MySQL

- [x] Spring Boot container
- [x] MySQL container
- [x] Docker network
- [x] `application.yml`
- [x] MySQL database configuration
- [ ] Verify application → MySQL connection
- [ ] Create Entity
- [ ] Create Repository
- [ ] Create CRUD API

## Next Steps

- [ ] Verify Spring Boot → MySQL connection
- [ ] Complete CRUD
- [ ] Add health checks
- [ ] Learn `.env`
- [ ] Improve Dockerfile
- [ ] Multi-stage build
- [ ] Redis
- [ ] Nginx
- [ ] Frontend container
- [ ] Kafka
- [ ] CI/CD
- [ ] Docker Registry
- [ ] Linux deployment
- [ ] Monitoring
- [ ] Kubernetes

---

# Docker Command Cheat Sheet

## Images

```bash
docker images
docker pull <image>
docker build -t <name> .
docker rmi <image>
docker tag <image> <repository>:<tag>
docker push <repository>:<tag>
```

## Containers

```bash
docker ps
docker ps -a
docker run <image>
docker start <container>
docker stop <container>
docker restart <container>
docker rm <container>
docker logs <container>
docker exec -it <container> bash
docker inspect <container>
docker stats
```

## Networks

```bash
docker network ls
docker network create <network>
docker network inspect <network>
docker network connect <network> <container>
docker network disconnect <network> <container>
```

## Volumes

```bash
docker volume ls
docker volume create <volume>
docker volume inspect <volume>
docker volume rm <volume>
```

## Compose

```bash
docker compose up
docker compose up -d
docker compose up -d --build
docker compose up -d --force-recreate
docker compose down
docker compose ps
docker compose logs
docker compose logs -f
docker compose build
docker compose pull
docker compose restart
```

---

# Learning Method

For every Docker concept:

```text
1. Learn the concept
       ↓
2. Write the configuration
       ↓
3. Run it
       ↓
4. Inspect it
       ↓
5. Break it intentionally
       ↓
6. Debug it
       ↓
7. Fix it
       ↓
8. Document it
```

Do not learn Docker only by memorizing commands.

For every command, understand:

```text
What does it do?
Why do I need it?
What changes after running it?
Where is the data?
Which container is affected?
Which network is used?
```

---

# Golden Rules

### 1. Image is not Container

```text
Image = Blueprint
Container = Running instance of an image
```

### 2. Containers are disposable

Important data should not depend on the container filesystem.

Use volumes for persistent data.

### 3. Containers communicate through networks

Inside Docker Compose:

```text
mysql:3306
```

is normally used instead of:

```text
localhost:3306
```

### 4. `ports` exposes containers to the host

```yaml
ports:
  - "8080:8080"
```

means:

```text
Host:8080 → Container:8080
```

### 5. Understand before copying

Do not blindly run:

```bash
docker compose up -d
```

Understand what Compose creates:

```text
Network
Container
Volume
Image
Port mapping
Environment
```

---

# Final Goal

By completing this roadmap, I should be able to:

- Build Docker images
- Write production-ready Dockerfiles
- Run and debug containers
- Manage Docker networks
- Manage persistent volumes
- Use Docker Compose
- Containerize Spring Boot applications
- Containerize Node.js applications
- Containerize Python applications
- Run MySQL/PostgreSQL/Redis/MongoDB
- Build multi-container applications
- Configure Nginx
- Use Redis and Kafka
- Build microservice environments
- Optimize Docker images
- Secure containers
- Build CI/CD pipelines
- Push images to registries
- Deploy Docker applications to Linux servers
- Monitor containerized applications
- Understand cloud container platforms
- Transition from Docker Compose to Kubernetes

---

# Learning Philosophy

> Docker is not the final goal. Docker is the foundation for learning modern application deployment.

The target is to understand the complete lifecycle:

```text
Code
 ↓
Dockerfile
 ↓
Image
 ↓
Container
 ↓
Network
 ↓
Volume
 ↓
Compose
 ↓
CI/CD
 ↓
Registry
 ↓
Server
 ↓
Monitoring
 ↓
Production
 ↓
Kubernetes
```

---

## Repository

GitHub: [nguyentrung01ute-ui/test-docker](https://github.com/nguyentrung01ute-ui/test-docker)
