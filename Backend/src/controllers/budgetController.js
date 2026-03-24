const pool = require('../config/database');

// Gets budget for the current month or specified month/year
exports.getBudgets = async (req, res) => {
  try {
    const userId = req.user.id;
    const { month, year } = req.query;
    const currentMonth = month || new Date().getMonth() + 1;
    const currentYear = year || new Date().getFullYear();

    const result = await pool.query(
      `SELECT * FROM budgets WHERE user_id = $1 AND month = $2 AND year = $3`,
      [userId, currentMonth, currentYear]
    );

    res.status(200).json(result.rows);
  } catch (error) {
    console.error("Get Budgets Error:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Set or update budget for a category
exports.setBudget = async (req, res) => {
  try {
    const userId = req.user.id;
    const { category, amount, month, year } = req.body;
    
    if (!category || amount === undefined) {
      return res.status(400).json({ message: "Category and amount are required" });
    }

    const currentMonth = month || new Date().getMonth() + 1;
    const currentYear = year || new Date().getFullYear();

    const result = await pool.query(
      `INSERT INTO budgets (user_id, category, amount, month, year)
       VALUES ($1, $2, $3, $4, $5)
       ON CONFLICT (user_id, category, month, year)
       DO UPDATE SET amount = EXCLUDED.amount, updated_at = CURRENT_TIMESTAMP
       RETURNING *`,
      [userId, category, parseFloat(amount), currentMonth, currentYear]
    );

    res.status(200).json({
      message: "Budget updated successfully",
      budget: result.rows[0],
    });
  } catch (error) {
    console.error("Set Budget Error:", error);
    res.status(500).json({ message: "Server error" });
  }
};

exports.getBudgetProgress = async (req, res) => {
    try {
        const userId = req.user.id;
        const { month, year } = req.query;
        const currentMonth = month || new Date().getMonth() + 1;
        const currentYear = year || new Date().getFullYear();

        const query = `
            SELECT 
                b.category, 
                b.amount as budget_amount, 
                COALESCE(SUM(e.amount), 0) as spent_amount,
                (b.amount - COALESCE(SUM(e.amount), 0)) as remaining_amount
            FROM budgets b
            LEFT JOIN expenses e ON b.category = e.category AND b.user_id = e.user_id 
                AND EXTRACT(MONTH FROM e.expense_date) = b.month 
                AND EXTRACT(YEAR FROM e.expense_date) = b.year
            WHERE b.user_id = $1 AND b.month = $2 AND b.year = $3
            GROUP BY b.category, b.amount
        `;

        const result = await pool.query(query, [userId, currentMonth, currentYear]);
        res.status(200).json(result.rows);
    } catch (error) {
        console.error("Budget Progress Error:", error);
        res.status(500).json({ message: "Server error" });
    }
};
