const express = require('express');
const cors = require('cors');

const expenseRoutes = require('./routes/expenseRoutes');
const authRoutes = require('./routes/authRoutes');
const dashboardRoutes = require("./routes/dashboardRoutes");
const userRoutes = require("./routes/userRoutes");
const analyticsRoutes = require("./routes/analyticsRoutes");
const categoryRoutes = require("./routes/categoryRoutes");
const budgetRoutes = require("./routes/budgetRoutes");

const app = express();

app.use(cors());
app.use(express.json());

// Run migration script
const pool = require('./config/database');
const setupDb = async () => {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS categories (
          id SERIAL PRIMARY KEY,
          user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
          name VARCHAR(100) NOT NULL,
          icon_name VARCHAR(100) NOT NULL,
          color_hex VARCHAR(20) NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          UNIQUE(user_id, name)
      );
    `);
    await pool.query(`
      CREATE TABLE IF NOT EXISTS budgets (
          id SERIAL PRIMARY KEY,
          user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
          monthly_limit NUMERIC(10, 2) NOT NULL DEFAULT 0,
          month INTEGER NOT NULL,
          year INTEGER NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          UNIQUE(user_id, month, year)
      );
    `);
    // Ensure expenses table has category_id column
    await pool.query(`
      ALTER TABLE expenses 
      ADD COLUMN IF NOT EXISTS category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL;
    `);
    console.log("Database schema updated.");
  } catch (err) {
    console.error("Failed to run migrations on startup", err);
  }
};
setupDb();

app.use('/api/auth', authRoutes);
app.use('/api/expenses', expenseRoutes);
app.use("/dashboard", dashboardRoutes);
app.use("/api/user", userRoutes);
app.use("/api/analytics", analyticsRoutes);
app.use("/api/categories", categoryRoutes);
app.use("/api/budgets", budgetRoutes);

module.exports = app;