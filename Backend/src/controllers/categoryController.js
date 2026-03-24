const pool = require('../config/database');

// Get categories for a user
const getCategories = async (req, res) => {
  try {
    const userId = req.user.id;
    const result = await pool.query(
      "SELECT * FROM categories WHERE user_id = $1 OR user_id IS NULL ORDER BY name ASC",
      [userId]
    );
    res.status(200).json(result.rows);
  } catch (error) {
    console.error("Get Categories Error:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Add a category
const addCategory = async (req, res) => {
  try {
    const { name, icon_name, color_hex } = req.body;
    const userId = req.user.id;

    if (!name || !icon_name || !color_hex) {
      return res.status(400).json({ message: "All fields are required" });
    }

    const result = await pool.query(
      "INSERT INTO categories (user_id, name, icon_name, color_hex) VALUES ($1, $2, $3, $4) RETURNING *",
      [userId, name, icon_name, color_hex]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error("Add Category Error:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Delete a category
const deleteCategory = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;

    await pool.query(
      "DELETE FROM categories WHERE id = $1 AND user_id = $2",
      [id, userId]
    );

    res.status(200).json({ message: "Category deleted" });
  } catch (error) {
    console.error("Delete Category Error:", error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { getCategories, addCategory, deleteCategory };
