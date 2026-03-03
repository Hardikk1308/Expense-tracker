const express = require('express');
const dotenv = require('dotenv');
const path = require('path');
const authRoutes = require('./src/routes/authRoutes');

// Load environment variables from Backend/.env
dotenv.config({ path: path.join(__dirname, '.env') });

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

// Auth routes
app.use('/auth', authRoutes);

// Add expense routes
app.use('/api/expenses', expenseRoutes);

app.listen(port,"0.0.0.0", () => {
    console.log(`Server is running on port ${port}`);
});
