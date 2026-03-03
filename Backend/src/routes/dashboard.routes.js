const express = require("express");
const router = express.Router();
// const dashboardController = require("../controllers/dashboard.controller");
const dashboardController = require("../controllers/Dashboard.Controller"); 
const authMiddleware = require("../middleware/auth.middleware");

router.get("/", authMiddleware, dashboardController.getDashboard);

module.exports = router;