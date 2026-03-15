const express = require("express");
const router = express.Router();
const { updateBudget, updatePreferences } = require("../controllers/userController");
const { authenticateToken } = require("../middlewares/authMiddleware");

router.put("/budget", authenticateToken, updateBudget);
router.put("/preferences", authenticateToken, updatePreferences);

module.exports = router;