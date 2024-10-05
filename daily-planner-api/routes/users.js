const express = require('express');
const router = express.Router();
const User = require('../models/User');

// Endpoint GET /users (lấy tất cả users)
router.get('/', async (req, res) => {
  try {
    const users = await User.getAllUsers();
    res.json(users);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Endpoint POST /users (kiểm tra login)
router.post('/', async (req, res) => {
  try {
    const { email, password } = req.body;
    const users = await User.getAllUsers(); 
    const user = users.find(
      (user) => user.email === email && user.password === password
    );

    if (user) {
      res.json({ message: 'Login successful', user });
    } else {
      res.status(401).json({ message: 'Invalid email or password' });
    }
  } catch (error) {
    console.error('Error during login:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;