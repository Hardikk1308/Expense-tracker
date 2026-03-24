const express = require('express');
const {
  getBudgets,
  setBudget,
  getBudgetProgress,
} = require('../controllers/budgetController');

const { authenticateToken } = require('../middlewares/authMiddleware');

const router = express.Router();

router.get('/', authenticateToken, getBudgets);
router.post('/', authenticateToken, setBudget);
router.get('/progress', authenticateToken, getBudgetProgress);

module.exports = router;
