const bcrypt = require('bcrypt');
const pool = require('../config/database');

// ================= ADD EXPENSE =================
const addExpense = async (req, res) => {
    try {
        const { amount, category, description, expense_date } = req.body;

        const userId = req.user.id; // comes from auth middleware

        // Validation
        if (!amount || !category) {
            return res.status(400).json({
                message: "Amount and category are required",
            });
        }

        const result = await pool.query(
            `INSERT INTO expenses 
       (user_id, amount, category, description, expense_date) 
       VALUES ($1, $2, $3, $4, $5)
       RETURNING *`,
            [userId, amount, category, description || null, expense_date || new Date()]
        );

        res.status(201).json({
            message: "Expense added successfully",
            expense: result.rows[0],
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server error" });
    }
};

// ================= GET EXPENSES =================
const getExpenses = async (req, res) => {
  try {
    const userId = req.user.id;

    const result = await pool.query(
      "SELECT * FROM expenses WHERE user_id = $1 ORDER BY expense_date DESC",
      [userId]
    );

    res.json(result.rows);

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
};

// ========================DELETE=======================
const deleteExpense = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;

    const result = await pool.query(
      "DELETE FROM expenses WHERE id = $1 AND user_id = $2 RETURNING *",
      [id, userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Expense not found" });
    }

    res.json({ message: "Expense deleted" });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
};