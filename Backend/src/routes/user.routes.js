const express = require("express");
const router = express.Router();
const { updateBudget } = require("../controllers/user.controller");
const { authenticateToken } = require("../middlewares/authMiddleware");

router.put("/budget", authenticateToken, updateBudget);

module.exports = router;