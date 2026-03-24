const express = require('express');
const router = express.Router();
const { getCategoryBreakdown, getSpendingTrends, getInsights } = require('../controllers/analyticsController');
const { authenticateToken } = require('../middlewares/authMiddleware');

router.get('/category-breakdown', authenticateToken, getCategoryBreakdown);
router.get('/trends', authenticateToken, getSpendingTrends);
router.get('/insights', authenticateToken, getInsights);

module.exports = router;
