const pool = require("../config/database");

exports.updateBudget = async (req, res) => {
  try {
    const userId = req.user.id;
    const { monthly_budget } = req.body;

    const query = `
      UPDATE users
      SET monthly_budget = $1
      WHERE id = $2
      RETURNING monthly_budget
    `;

    const result = await pool.query(query, [monthly_budget, userId]);

    res.json({
      message: "Budget updated",
      budget: result.rows[0].monthly_budget
    });

  } catch (error) {
    console.error("Budget error:", error);
    res.status(500).json({ message: "Server error" });
  }
};