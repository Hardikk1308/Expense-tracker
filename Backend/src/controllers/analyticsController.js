const pool = require('../config/database');

exports.getCategoryBreakdown = async (req, res) => {
  try {
    const userId = req.user.id;
    const { month, year } = req.query; // e.g., ?month=10&year=2024

    let query = `
      SELECT category, SUM(amount) as total
      FROM expenses
      WHERE user_id = $1
    `;
    const params = [userId];

    if (month && year) {
      query += ` AND EXTRACT(MONTH FROM expense_date) = $2 AND EXTRACT(YEAR FROM expense_date) = $3`;
      params.push(month, year);
    } else {
      // Default to current month
      query += ` AND DATE_TRUNC('month', expense_date) = DATE_TRUNC('month', CURRENT_DATE)`;
    }

    query += ` GROUP BY category ORDER BY total DESC`;

    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (error) {
    console.error("Analytics Error (Category Breakdown):", error);
    res.status(500).json({ message: "Server error" });
  }
};

exports.getSpendingTrends = async (req, res) => {
  try {
    const userId = req.user.id;

    // Daily spending for the current month
    const query = `
      SELECT DATE(expense_date) as date, SUM(amount) as total
      FROM expenses
      WHERE user_id = $1
      AND DATE_TRUNC('month', expense_date) = DATE_TRUNC('month', CURRENT_DATE)
      GROUP BY DATE(expense_date)
      ORDER BY date ASC
    `;

    const result = await pool.query(query, [userId]);
    res.json(result.rows);
  } catch (error) {
    console.error("Analytics Error (Spending Trends):", error);
    res.status(500).json({ message: "Server error" });
  }
};
exports.getInsights = async (req, res) => {
  try {
    const userId = req.user.id;
    
    // Get highest spending category for the current month
    const query = `
      SELECT category, SUM(amount) as total
      FROM expenses
      WHERE user_id = $1 AND DATE_TRUNC('month', expense_date) = DATE_TRUNC('month', CURRENT_DATE)
      GROUP BY category
      ORDER BY total DESC
      LIMIT 1
    `;
    const result = await pool.query(query, [userId]);
    
    if (result.rows.length === 0) {
      return res.json({ insights: ["Start adding expenses to see insights!"] });
    }

    const mainCategory = result.rows[0];
    const insights = [
      `Your main spending this month is on ${mainCategory.category} (₹${parseFloat(mainCategory.total).toFixed(2)}).`,
      `Consider setting a budget for ${mainCategory.category} to save more.`
    ];

    res.json({ insights });
  } catch (error) {
    console.error("Analytics Error (Insights):", error);
    res.status(500).json({ message: "Server error" });
  }
};
