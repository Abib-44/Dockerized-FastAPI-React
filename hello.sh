
# requirements.txt
echo "fastapi==0.104.1
uvicorn==0.24.0
sqlalchemy==2.0.23
psycopg2-binary==2.9.9" > backend/requirements.txt

# models.py
echo "from sqlalchemy import Column, Integer, String, Boolean, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

DATABASE_URL = \"postgresql://user:password@db:5432/todos\"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

class Todo(Base):
    __tablename__ = \"todos\"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    completed = Column(Boolean, default=False)

Base.metadata.create_all(bind=engine)" > backend/models.py

# main.py
echo "from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from models import SessionLocal, Todo
from pydantic import BaseModel

app = FastAPI()

class TodoCreate(BaseModel):
    title: str

class TodoUpdate(BaseModel):
    title: str = None
    completed: bool = None

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post(\"/todos/\")
def create_todo(todo: TodoCreate, db: Session = Depends(get_db)):
    db_todo = Todo(title=todo.title)
    db.add(db_todo)
    db.commit()
    db.refresh(db_todo)
    return db_todo

@app.get(\"/todos/\")
def read_todos(db: Session = Depends(get_db)):
    return db.query(Todo).all()

@app.put(\"/todos/{todo_id}\")
def update_todo(todo_id: int, todo: TodoUpdate, db: Session = Depends(get_db)):
    db_todo = db.query(Todo).filter(Todo.id == todo_id).first()
    if not db_todo:
        raise HTTPException(status_code=404, detail=\"Todo not found\")
    if todo.title is not None:
        db_todo.title = todo.title
    if todo.completed is not None:
        db_todo.completed = todo.completed
    db.commit()
    return db_todo

@app.delete(\"/todos/{todo_id}\")
def delete_todo(todo_id: int, db: Session = Depends(get_db)):
    db_todo = db.query(Todo).filter(Todo.id == todo_id).first()
    if not db_todo:
        raise HTTPException(status_code=404, detail=\"Todo not found\")
    db.delete(db_todo)
    db.commit()
    return {\"message\": \"Todo deleted\"}" > backend/main.py

# backend Dockerfile
echo "FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD [\"uvicorn\", \"main:app\", \"--host\", \"0.0.0.0\", \"--port\", \"8000\"]" > backend/Dockerfile

# --- FRONTEND ---

# package.json
echo "{
  \"name\": \"frontend\",
  \"version\": \"0.1.0\",
  \"private\": true,
  \"dependencies\": {
    \"react\": \"^18.2.0\",
    \"react-dom\": \"^18.2.0\",
    \"react-scripts\": \"5.0.1\"
  },
  \"scripts\": {
    \"start\": \"react-scripts start\",
    \"build\": \"react-scripts build\",
    \"test\": \"react-scripts test\",
    \"eject\": \"react-scripts eject\"
  }
}" > frontend/package.json

# public/index.html
echo "<!DOCTYPE html>
<html lang=\"en\">
  <head>
    <meta charset=\"utf-8\" />
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />
    <title>Todo App</title>
  </head>
  <body>
    <div id=\"root\"></div>
  </body>
</html>" > frontend/public/index.html

# src/index.js
echo "import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);" > frontend/src/index.js

# src/App.js
echo "import React from 'react';
import TodoList from './TodoList';

function App() {
  return (
    <div className=\"App\">
      <h1>Todo App</h1>
      <TodoList />
    </div>
  );
}

export default App;" > frontend/src/App.js

# src/TodoList.js
echo "import React, { useState, useEffect } from 'react';

function TodoList() {
  const [todos, setTodos] = useState([]);
  const [newTodo, setNewTodo] = useState('');

  useEffect(() => {
    fetchTodos();
  }, []);

  const fetchTodos = async () => {
    const response = await fetch('http://localhost:8000/todos/');
    const data = await response.json();
    setTodos(data);
  };

  const addTodo = async () => {
    if (newTodo.trim()) {
      await fetch('http://localhost:8000/todos/', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title: newTodo }),
      });
      setNewTodo('');
      fetchTodos();
    }
  };

  const toggleTodo = async (id, completed) => {
    await fetch(\`http://localhost:8000/todos/\${id}\`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ completed: !completed }),
    });
    fetchTodos();
  };

  const deleteTodo = async (id) => {
    await fetch(\`http://localhost:8000/todos/\${id}\`, {
      method: 'DELETE',
    });
    fetchTodos();
  };

  return (
    <div>
      <input
        type=\"text\"
        value={newTodo}
        onChange={(e) => setNewTodo(e.target.value)}
        placeholder=\"Add a new todo\"
      />
      <button onClick={addTodo}>Add</button>
      <ul>
        {todos.map((todo) => (
          <li key={todo.id}>
            <span
              style={{ textDecoration: todo.completed ? 'line-through' : 'none' }}
              onClick={() => toggleTodo(todo.id, todo.completed)}
            >
              {todo.title}
            </span>
            <button onClick={() => deleteTodo(todo.id)}>Delete</button>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default TodoList;" > frontend/src/TodoList.js

# frontend Dockerfile
echo "FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
CMD [\"npm\", \"start\"]" > frontend/Dockerfile

# docker-compose.yml
echo "version: '3.8'

services:
  db:
    image: postgres:15
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: todos
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - \"5432:5432\"

  backend:
    build: ./backend
    ports:
      - \"8000:8000\"
    depends_on:
      - db
    environment:
      - DATABASE_URL=postgresql://user:password@db:5432/todos

  frontend:
    build: ./frontend
    ports:
      - \"3000:3000\"
    depends_on:
      - backend

volumes:
  postgres_data:" > docker-compose.yml

# README.md
echo "# Full-Stack Todo App

Backend: FastAPI + PostgreSQL
Frontend: React
Dockerized with docker-compose" > README.md

echo "Progetto completo creato nella directory corrente con backend, frontend e Docker setup pronto."
