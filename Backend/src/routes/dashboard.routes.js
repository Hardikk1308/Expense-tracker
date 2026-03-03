const express = require("express");
const router = express.Router();

const dashboardController = require("../controllers/Dashboard.Controller"); 
const { authenticateToken } = require('../middlewares/authMiddleware');

router.get("/", authenticateToken, dashboardController.getDashboard);

module.exports = router;