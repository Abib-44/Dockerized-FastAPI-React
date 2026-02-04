import React, { useState, useEffect } from 'react';

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
    await fetch(`http://localhost:8000/todos/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ completed: !completed }),
    });
    fetchTodos();
  };

  const deleteTodo = async (id) => {
    await fetch(`http://localhost:8000/todos/${id}`, {
      method: 'DELETE',
    });
    fetchTodos();
  };

  return (
    <div className="todo">
      <div className="todo__input-group">
        <input
          type="text"
          value={newTodo}
          onChange={(e) => setNewTodo(e.target.value)}
          placeholder="Add a new todo"
          className="todo__input"
        />
        <button onClick={addTodo} className="todo__add-btn">
          Add
        </button>
      </div>

      <ul className="todo__list">
        {todos.map((todo) => (
          <li key={todo.id} className="todo__item">
            <span
              className={`todo__text ${todo.completed ? 'todo__text--completed' : ''}`}
              onClick={() => toggleTodo(todo.id, todo.completed)}
            >
              {todo.title}
            </span>
            <button
              onClick={() => deleteTodo(todo.id)}
              className="todo__delete-btn"
            >
              Delete
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default TodoList;
