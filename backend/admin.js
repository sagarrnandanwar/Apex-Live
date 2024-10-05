const express = require('express');
const pool = require('./database'); 
require('dotenv').config();
const app = express();
const port = process.env.ADMIN_PORT;
const { printValue, printLog } = require('./print');
const cors = require('cors')
const jwt = require('jsonwebtoken');
const secretKey='apex_live'

app.use(express.json());
app.use(cors())


function authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ error: 'Token is missing' }); // Return error message
    }

    jwt.verify(token, secretKey, (err, user) => {
        if (err) {
            return res.status(403).json({ error: 'Token is invalid' }); // Return error message
        }
        // Attach user info to the request object
        req.user = user; // The decoded token will contain userId and admin status
        req.error = false; // Set error to false if authenticated
        next(); 
    });
}

// Endpoint to authenticate token
app.get('/authenticateToken', authenticateToken, (req, res) => {
    res.status(200).json({ 
        message: 'Token is valid', 
        error: req.error, 
        isAdmin: req.user.admin // Send the admin status
    });
});


app.post('/login', async (req, res) => {
    const { name, password } = req.body;

    // Validate input
    if (!name || !password) {
        console.log('-> Missing name or password');
        return res.status(400).json({ error: 'name and password are required' });
    }

    try {
        const { rows } = await pool.query('SELECT id, pass, is_admin FROM employees WHERE full_name = $1', [name]);

        if (rows.length === 0) {
            console.log('-> User not found with:', name);
            return res.status(401).json({ error: 'Invalid name or password' });
        }

        const storedPassword = rows[0].pass;

        // Compare passwords (simple comparison for this example)
        if (password === storedPassword) {
            const token = jwt.sign({ userId: rows[0].id, isAdmin: (rows[0].is_admin !== 0) }, secretKey, { expiresIn: '4h' });
            console.log('-> Login request successful with:', name);
            return res.status(200).json({
                user: {
                    id: rows[0].id,
                    full_name: name,
                    isAdmin: rows[0].is_admin !== 0,
                },
                token,
                admin: rows[0].is_admin !== 0
            });
        } else {
            return res.status(401).json({ error: 'Invalid name or password' });
        }
    } catch (err) {
        console.error('Error occurred:', err.message);
        return res.status(500).json({ error: 'Internal Server Error' });
    }
});


app.listen(port, () => {
    console.log(`\n\n\t\t\x1b[37m[⚡️] Apex Live admin server has started on \x1b[36mhttp://localhost:${port}\n\x1b[37m`);
});
