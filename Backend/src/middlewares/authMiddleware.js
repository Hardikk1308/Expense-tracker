const jwt = require('jsonwebtoken');

const authenticateToken = (req, res, next) => {
    const authHeader = req.headers.authorization;

    if (!authHeader) {
        return res.status(401).json({ message: 'Unauthorized - No token provided' });
    }

    // Expecting: "Bearer TOKEN"
    const token = authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ message: 'Unauthorized - Invalid token format' });
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded;  // store decoded payload properly
        next();
    } catch (err) {
        console.log("JWT Error:", err.message);
        return res.status(403).json({ message: 'Invalid or expired token' });
    }
};

module.exports = { authenticateToken };