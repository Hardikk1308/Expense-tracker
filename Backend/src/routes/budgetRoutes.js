const express = require('express');
const { getBudget, setBudget } = require('../controllers/budgetController');
const { authenticateToken } = require('../middlewares/authMiddleware');

const router = express.Router();

router.get('/', authenticateToken, getBudget);
router.post('/', authenticateToken, setBudget);

module.exports = router;
