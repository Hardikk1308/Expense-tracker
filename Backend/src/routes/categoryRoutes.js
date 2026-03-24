const express = require('express');
const { getCategories, addCategory, deleteCategory } = require('../controllers/categoryController');
const { authenticateToken } = require('../middlewares/authMiddleware');

const router = express.Router();

router.get('/', authenticateToken, getCategories);
router.post('/', authenticateToken, addCategory);
router.delete('/:id', authenticateToken, deleteCategory);

module.exports = router;
