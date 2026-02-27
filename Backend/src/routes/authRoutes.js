const express = require('express');
const { register, login, getUserInfo } = require('../Auth/authController');
const { authenticateToken } = require('../middlewares/authMiddleware');

const router = express.Router();

// Auth routes
router.post('/register', register);
router.post('/login', login);
router.get('/userinfo', authenticateToken, getUserInfo);

module.exports = router;
