import React from 'react';
import TodoList from './TodoList';
import './App.css';

const App = () => {
  return (
    <div className="app">
      <header className="app__header">
        <h1 className="app__title">📝 Todo App</h1>
        <p className="app__subtitle">
          Manage your tasks quickly and efficiently
        </p>
      </header>

      <main className="app__main">
        <section className="todo-section">
          <TodoList />
        </section>
      </main>

    </div>
  );
};

export default App;
