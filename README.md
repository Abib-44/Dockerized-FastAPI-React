# 📝 Todo App - Fullstack with Docker

A modern, containerized **Todo App** built with **React (frontend)**, **FastApi backend**, **PostgreSQL**, and **pgAdmin**. Designed for fast development, multi-developer environments, and easy setup with Docker Compose.  

---

## 🚀 Features

- Add, edit, and delete todos in a sleek interface  
- Backend API fully containerized and configurable via environment variables  
- PostgreSQL database with isolated initialization  
- pgAdmin container for database management  
- Hot-reloading frontend with Docker volumes  
- Robust startup: backend and pgAdmin wait for the database to be ready using `wait-for-it.sh`  

---

## 🛠️ Tech Stack

| Layer       | Technology                  |
|------------|-----------------------------|
| Frontend    | React, TailwindCSS (optional) |
| Backend     | Node.js / Python (example)   |
| Database    | PostgreSQL 15               |
| DB Admin   | pgAdmin 4                    |
| Container  | Docker + Docker Compose      |

---

## 📦 Setup

### 1. Clone the repository

```bash
git clone git@github.com:Abib-44/Dockerized-FastAPI-React.git
cd todo-app
```

🔧 Useful Commands
```
# Build and start everything
docker-compose up --build

# Stop all containers
docker-compose down

# Rebuild backend only
docker-compose build backend

# Run database migrations manually (if needed)
docker exec -it todo-app_backend_1 npm run migrate
```
