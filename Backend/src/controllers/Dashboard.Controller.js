// const dashboardService = require("../services/dashboard.service");
const dashboardService = require("../services/dashboard.Service");

exports.getDashboard = async (req, res) => {
  try {
    const userId = req.user.id;

    const data = await dashboardService.getDashboardData(userId);

    res.status(200).json(data);
  } catch (error) {
    console.error("Dashboard error:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};