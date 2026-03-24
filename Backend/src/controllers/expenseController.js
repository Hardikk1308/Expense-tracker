const pool = require('../config/database');

// ================= ADD EXPENSE =================
const addExpense = async (req, res) => {
  try {
    const { amount, category, category_id, description, expense_date } = req.body;
    const userId = req.user.id;

    if (!amount) {
      return res.status(400).json({ message: "Amount is required" });
    }

    const result = await pool.query(
      `INSERT INTO expenses 
      (user_id, amount, category_id, category, description, expense_date) 
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING *`,
      [
        userId,
        parseFloat(amount),
        category_id || null,
        category || null,
        description || null,
        expense_date ? new Date(expense_date) : new Date()
      ]
    );

    res.status(201).json({
      message: "Expense added successfully",
      expense: result.rows[0],
    });

  } catch (error) {
    console.error("Add Expense Error:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// ================= GET EXPENSES =================
const getExpenses = async (req, res) => {
  try {
    const userId = req.user.id;

    const result = await pool.query(
      `SELECT e.*, c.name as category_name, c.icon_name, c.color_hex 
       FROM expenses e 
       LEFT JOIN categories c ON e.category_id = c.id 
       WHERE e.user_id = $1 
       ORDER BY e.expense_date DESC`,
      [userId]
    );

    res.status(200).json(result.rows);

  } catch (error) {
    console.error("Get Expenses Error:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// ================= DELETE EXPENSE =================
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

    res.status(200).json({ message: "Expense deleted successfully" });

  } catch (error) {
    console.error("Delete Expense Error:", error);
    res.status(500).json({ message: "Server error" });
  }
};

//================== UPDATE EXPENSE =================
const updateExpense = async (req, res) => {
  try {
    const { id } = req.params;
    if (isNaN(id)) {
      return res.status(400).json({ message: "Invalid expense id" });
    }

    const { amount, category, category_id, description, expense_date } = req.body;
    const userId = req.user.id;

    const result = await pool.query(
      `UPDATE expenses SET 
        amount = COALESCE($1, amount),
        category = COALESCE($2, category),
        category_id = COALESCE($3, category_id),
        description = COALESCE($4, description),
        expense_date = COALESCE($5, expense_date)
      WHERE id = $6 AND user_id = $7
      RETURNING *`,
      [
        amount !== undefined ? amount : null,
        category !== undefined ? category : null,
        category_id !== undefined ? category_id : null,
        description !== undefined ? description : null,
        expense_date !== undefined ? new Date(expense_date) : null,
        id,
        userId
      ]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Expense not found or unauthorized" });
    }

    res.status(200).json({
      message: "Expense updated successfully",
      expense: result.rows[0],
    });

  } catch (error) {
    console.error("Update Expense Error:", error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = {
  addExpense,
  getExpenses,
  deleteExpense,
  updateExpense,
};