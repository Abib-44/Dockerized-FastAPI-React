# FastAPI PostgreSQL pgAdmin Docker Project

This project is a fully containerized Python backend application built with **FastAPI**, **PostgreSQL**, and **pgAdmin**. It demonstrates a clean project structure, database integration, and basic user management. The goal is to provide a solid starting point for scalable API development.

---

## Project Structure

```bash
.
├── app
│ ├── database.py # Database connection and setup
│ ├── init.py
│ ├── main.py # FastAPI app entrypoint
│ ├── models
│ │ ├── init.py
│ │ └── user.py # User ORM model
│ ├── schemas
│ │ ├── init.py
│ │ └── user.py # Pydantic schemas for User
│ └── services
│ ├── init.py
│ └── user_service.py # Business logic for User
├── db
│ └── init
│ └── 01_schema.sql # Initial database schema
├── Dockerfile # Dockerfile for FastAPI app
├── compose.yaml # Docker Compose file for all containers
├── requirements.txt # Python dependencies
└── README.md
```


---

## Features

- **FastAPI backend** for building RESTful APIs
- **PostgreSQL database** with initial schema
- **pgAdmin** for database administration via browser
- **Dockerized** environment for easy setup and deployment
- **Modular project structure**: models, schemas, services

---

## Prerequisites

- Docker and Docker Compose installed
- Python 3.10+ if you want to run outside Docker

---

## Quick Start

1. **Clone the repository**:

```bash
git clone <repo_url>
cd <repo_folder>
```

And in the end

```bash
docker compose up --build
```