const pool = require('../config/database');

// Get budget for the current month
const getBudget = async (req, res) => {
  try {
    const userId = req.user.id;
    const { month, year } = req.query;

    if (!month || !year) {
      return res.status(400).json({ message: "Month and year required" });
    }

    // Get the limit
    const budgetResult = await pool.query(
      "SELECT * FROM budgets WHERE user_id = $1 AND month = $2 AND year = $3",
      [userId, month, year]
    );

    let budget = budgetResult.rows[0];

    // If no budget entry, create a default one or return zero limit
    if (!budget) {
      return res.status(200).json({
        monthly_limit: 0,
        current_spent: 0,
        month: parseInt(month),
        year: parseInt(year)
      });
    }

    // Calculate total spent for that month
    const expenseResult = await pool.query(
      "SELECT SUM(amount) as total FROM expenses WHERE user_id = $1 AND EXTRACT(MONTH FROM expense_date) = $2 AND EXTRACT(YEAR FROM expense_date) = $3",
      [userId, month, year]
    );

    budget.current_spent = parseFloat(expenseResult.rows[0].total) || 0;

    res.status(200).json(budget);
  } catch (error) {
    console.error("Get Budget Error:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Set/Update budget
const setBudget = async (req, res) => {
  try {
    const userId = req.user.id;
    const { monthly_limit, month, year } = req.body;

    if (monthly_limit === undefined || !month || !year) {
      return res.status(400).json({ message: "Monthly limit, month, and year are required" });
    }

    const result = await pool.query(
      `INSERT INTO budgets (user_id, monthly_limit, month, year)
       VALUES ($1, $2, $3, $4)
       ON CONFLICT (user_id, month, year)
       DO UPDATE SET monthly_limit = EXCLUDED.monthly_limit, updated_at = CURRENT_TIMESTAMP
       RETURNING *`,
      [userId, monthly_limit, month, year]
    );

    res.status(200).json(result.rows[0]);
  } catch (error) {
    console.error("Set Budget Error:", error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { getBudget, setBudget };
