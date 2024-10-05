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
    let token = authHeader && authHeader.split(' ')[1];



    if (!token) {
        token=req.token
        // return res.status(401).json({ error: 'Token is missing' }); // Return error message
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
        isAdmin: req.user.admin 
    });
});

app.get('/getEmployees',authenticateToken,async (req,res)=>{
    try{
        const { rows } = await pool.query('SELECT id, full_name, is_admin,phone_number FROM employees');
        res.status(200).json(rows);
    }catch(err){
        res.status(500).json({ error: 'Internal Server Error' });
    }
})

app.get('/getTalukas',authenticateToken,async (req,res)=>{
    try{
        const { rows } = await pool.query('SELECT id, taluka FROM taluka');

        res.status(200).json(rows);
    }catch(err){
        res.status(500).json({ error: 'Internal Server Error' });
    }
})


app.get('/getPollingStation',authenticateToken,async (req,res)=>{
    try{
            const query = `
            SELECT 
                ps.id, 
                ps.polling_station, 
                ps.polling_address, 
                t.taluka_name, 
                e.full_name AS operator_name 
            FROM 
                polling_stations ps
            JOIN 
                employees e ON ps.operator = e.id
            JOIN 
                taluka t ON ps.taluka = t.id;
           `;
        
        const { rows } = await pool.query(query);
        res.status(200).json(rows);
    }catch(err){
        res.status(500).json({ error: 'Internal Server Error' });
    }
})



app.post('/registerPollingStation',authenticateToken,async (req,res)=>{
    const {number,operator,address,taluka} = req.body
    console.log(`${number} ${operator} ${address} ${taluka}`)
    try{

        const operator_id = await pool.query('SELECT id FROM employees WHERE full_name = $1',[operator])
        const taluka_id = await pool.query('SELECT id FROM taluka WHERE taluka = $1',[taluka])
        console.log(operator_id.rows[0].id)
        console.log(taluka_id.rows[0].id)

        const result = await pool.query(
            'INSERT INTO polling_stations (polling_station, polling_address, taluka, operator) VALUES ($1, $2, $3, $4) RETURNING polling_station',
            [number,address,taluka_id.rows[0].id,operator_id.rows[0].id]
        );

        const PS_address = result.rows[0].polling_station;
        res.status(201).json({ message: 'Employee registered successfully.', name: PS_address,done:true });
        console.log("$ Polling Station registered with PS name : " + PS_address)
    }catch(e){
        console.log("error occured : "+e)
        res.status(201).json({ message: 'Employee not registered.',done:false });

    }
})


app.post('/registerEmployee',authenticateToken,async (req,res)=>{
    const {name,password,number,isAdmin} = req.body
    
    try{

        const result = await pool.query(
            'INSERT INTO employees (full_name, pass, is_admin, phone_number) VALUES ($1, $2, $3, $4) RETURNING full_name',
            [name, password, isAdmin ? 1 : 0, number]
        );

        const employeeName = result.rows[0].full_name;
        res.status(201).json({ message: 'Employee registered successfully.', name: employeeName,done:true });
        console.log("$ User registered with employee name : " + employeeName)
    }catch(e){
        console.log("error occured : "+e)
        res.status(201).json({ message: 'Employee not registered.',done:false });

    }
})


app.post('/registerTaluka',authenticateToken,async (req,res)=>{
    const {name} = req.body
    
    try{

        const result = await pool.query(
            'INSERT INTO taluka (taluka) VALUES ($1) RETURNING taluka',
            [name]
        );

        const talukaName = result.rows[0].taluka;
        res.status(201).json({ message: 'Employee registered successfully.', name: talukaName,done:true });
        console.log("$ Taluka registered with name : " + talukaName)
    }catch(e){
        console.log("error occured : "+e)
        res.status(201).json({ message: 'Employee not registered.',done:false });

    }
})


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
