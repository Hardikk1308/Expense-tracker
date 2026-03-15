const pool = require("../config/database");

exports.getCategories = async (req, res) => {
  try {
    const userId = req.user.id;
    // We allow setting custom categories. Also load defaults or just user ones?
    // User will manage their own entirely. If they have none, we can send default ones from frontend.
    const query = `SELECT * FROM categories WHERE user_id = $1 ORDER BY id ASC`;
    const result = await pool.query(query, [userId]);
    res.json(result.rows);
  } catch (err) {
    console.error("getCategories error:", err);
    res.status(500).json({ message: "Server error" });
  }
};

exports.addCategory = async (req, res) => {
  try {
    const userId = req.user.id;
    const { name, icon, color } = req.body;
    
    if (!name) {
      return res.status(400).json({ message: "Category name is required" });
    }

    const query = `
      INSERT INTO categories (user_id, name, icon, color)
      VALUES ($1, $2, $3, $4)
      RETURNING *
    `;
    const result = await pool.query(query, [userId, name, icon, color]);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error("addCategory error:", err);
    res.status(500).json({ message: "Server error" });
  }
};

exports.updateCategory = async (req, res) => {
  try {
    const userId = req.user.id;
    const categoryId = req.params.id;
    const { name, icon, color } = req.body;

    const query = `
      UPDATE categories
      SET name = COALESCE($1, name),
          icon = COALESCE($2, icon),
          color = COALESCE($3, color)
      WHERE id = $4 AND user_id = $5
      RETURNING *
    `;
    const result = await pool.query(query, [name, icon, color, categoryId, userId]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Category not found or unauthorized" });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error("updateCategory error:", err);
    res.status(500).json({ message: "Server error" });
  }
};

exports.deleteCategory = async (req, res) => {
  try {
    const userId = req.user.id;
    const categoryId = req.params.id;

    const query = `DELETE FROM categories WHERE id = $1 AND user_id = $2 RETURNING *`;
    const result = await pool.query(query, [categoryId, userId]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Category not found or unauthorized" });
    }
    res.json({ message: "Category deleted successfully" });
  } catch (err) {
    console.error("deleteCategory error:", err);
    res.status(500).json({ message: "Server error" });
  }
};
