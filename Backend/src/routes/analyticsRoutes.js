const express = require('express');
const router = express.Router();
const { getCategoryBreakdown, getSpendingTrends } = require('../controllers/analyticsController');
const { authenticateToken } = require('../middlewares/authMiddleware');

router.get('/category-breakdown', authenticateToken, getCategoryBreakdown);
router.get('/trends', authenticateToken, getSpendingTrends);

module.exports = router;
