const express = require('express');
const {
  addExpense,
  getExpenses,
  deleteExpense
} = require('../controllers/expenseController');

const { authenticateToken } = require('../middlewares/authMiddleware');

const router = express.Router();

// Routes
router.post('/', authenticateToken, addExpense);
router.get('/', authenticateToken, getExpenses);
router.delete('/:id', authenticateToken, deleteExpense);

module.exports = router;