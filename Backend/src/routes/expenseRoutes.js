const express = require('express');
const { addExpense, getExpenses, deleteExpense } = require('../Auth/expenseController');
const { authenticateToken } = require('../middlewares/authMiddleware');

const router = express.Router();

// Expense routes
router.post('/expenses', authenticateToken, addExpense);
router.get('/expenses', authenticateToken, getExpenses);
router.delete('/expenses/:id', authenticateToken, deleteExpense);

module.exports = router;