const pool = require("../config/database");

exports.getDashboardData = async (userId) => {
  const client = await pool.connect();

  try {
    // 1️⃣ Total expense this month
    const totalQuery = `
      SELECT COALESCE(SUM(amount), 0) AS total
      FROM expenses
      WHERE user_id = $1
      AND DATE_TRUNC('month', expense_date) = DATE_TRUNC('month', CURRENT_DATE);
    `;

    // 2️⃣ Get monthly budget
    const budgetQuery = `
      SELECT monthly_budget
      FROM users
      WHERE id = $1
    `;

    // 3️⃣ Recent transactions
    const recentQuery = `
      SELECT id, amount, category, description, expense_date
      FROM expenses
      WHERE user_id = $1
      ORDER BY expense_date DESC
      LIMIT 5
    `;

    const totalResult = await client.query(totalQuery, [userId]);
    const budgetResult = await client.query(budgetQuery, [userId]);
    const recentResult = await client.query(recentQuery, [userId]);

    const totalExpense = Number(totalResult.rows[0].total);
    const budget = Number(budgetResult.rows[0]?.monthly_budget || 0);

    const remaining = budget - totalExpense;
    const usedPercentage =
      budget > 0 ? Number(((totalExpense / budget) * 100).toFixed(1)) : 0;

    return {
      totalExpense,
      budget,
      remaining,
      usedPercentage,
      recentTransactions: recentResult.rows,
    };
  } finally {
    client.release();
  }
};