const express = require('express');
const pool = require('./database'); 
require('dotenv').config();
const app = express();
const port = process.env.ADMIN_PORT;
const cors = require('cors')
const jwt = require('jsonwebtoken');
const secretKey='apex_live'

let index=0


app.use(express.json());
app.use(cors())


function authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    let token = authHeader && authHeader.split(' ')[1];
    if (!token) {
        return res.status(401).json({ error: 'Token is missing' }); 
    }

    jwt.verify(token, secretKey, (err, user) => {
        if (err) {
            return res.status(403).json({ error: 'Token is invalid' }); 
        }

        req.admin= user.isAdmin
        req.user = user; 
        req.error = false;
        next(); 
    });
}

app.get('/authenticateToken', authenticateToken, (req, res) => {
    res.status(200).json({ 
        message: 'Token is valid', 
        error: req.error, 
        done:true,
        isAdmin: req.admin 
    });
});

async function alterTableQuery(table, info1, info2, info3, info4, reference) {
    switch (table) {
        case 'cameras': {
            console.log(`${info1}`);
            const trimmed_poll_station = info1.trim();
            
            const poll_id_result = await pool.query(
                'SELECT id FROM polling_stations WHERE polling_station = $1',
                [trimmed_poll_station]
            );

            if (poll_id_result.rows.length === 0) {
                throw new Error(`No polling station found for ${info1}`);
            }

            const poll_id = poll_id_result.rows[0].id;
            console.log('Polling station ID:', poll_id);

            const query = `
                UPDATE ${table}
                SET serial_number = $1, PS = $2
                WHERE id = $3
            `;

            return { query, params: [info1, poll_id, reference] };
        };
        case 'polling_stations': {

            console.log(`${info1}`);
            const trimmed_taluka = info3.trim();
            const trimmed_operator=info4.trim();

            const taluka_id = await pool.query(
                'SELECT id FROM taluka WHERE taluka = $1',
                [trimmed_taluka]
            );
            
            const operator_id = await pool.query(
                'SELECT id FROM employees WHERE full_name = $1',
                [trimmed_operator]
            )

            if (taluka_id.rows.length === 0 || operator_id.rows.length === 0) {
                throw new Error(`No polling station found for ${info3} or ${info4}`);
            }

            
            const query = `
                UPDATE ${table}
                SET polling_station = $1, polling_address = $2, taluka = $3, operator=$4 
                WHERE id = $5
            `;

            return { query, params: [info1,info2 ,taluka_id.rows[0].id , operator_id.rows[0].id, reference] };
        }
        case 'employees': {
         
            
            const query = `
                UPDATE ${table}
                SET full_name = $1, phone_number = $2, is_admin = $3
                WHERE id = $4
            `;

            return { query, params: [info1,info2 ,info3?1:0 , reference] };
        }
        case 'taluka': {
         
            
            const query = `
                UPDATE ${table}
                SET taluka = $1
                WHERE id = $2
            `;

            return { query, params: [info1, reference] };
        }
    }
}

app.post('/editItem', authenticateToken, async (req, res) => {
    const { info1, info2, info3, info4, reference, table } = req.body;

    try {
        // Get the query and parameters
        const { query, params } = await alterTableQuery(table, info1, info2, info3, info4, reference);


        // Execute the query
        const { rows } = await pool.query(query, params);

        res.status(200).json({ done: true, info: table });
        console.log('Table altered : ' +table)
    } catch (err) {
        console.error('error:', err.message);
        res.status(500).json({ done: false, message: err.message });
    }
});


app.post('/deleteItem',authenticateToken,async (req,res)=>{
    const {table,reference} =req.body
    try{
        const query=`
            DELETE FROM ${table}
            WHERE id = $1
        `
        const { rows } = await pool.query(query, [reference]);
        res.status(200).json({ done: true, info: table });
        console.log('[-] Item deleted : ' +table)

    }catch(err){
        console.log("Error occured : "+err)
    }
})



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


app.get('/getCameras',authenticateToken,async (req,res)=>{
    try{
        const query = `        
            SELECT 
            cameras.id AS "camera_id",
            cameras.serial_number AS "serial_number",
            taluka.taluka AS "taluka_name",
            cameras.stream_url AS "stream_url",
            polling_stations.polling_station AS "polling_station",
            employees.full_name AS "operator_name",
            employees.phone_number AS "operator_phone",
            cameras.is_active AS "is_active",
            polling_stations.polling_address AS "polling_address"
            FROM cameras
            LEFT JOIN polling_stations ON cameras.PS = polling_stations.id
            LEFT JOIN employees ON polling_stations.operator = employees.id
            LEFT JOIN taluka ON polling_stations.taluka = taluka.id;
        `;    
    

        const { rows } = await pool.query(query);

        res.status(200).json(rows);
    }catch(err){
        res.status(500).json({ error: 'Internal Server Error' });
    }
})


app.get('/',(req,res)=>{
    console.log(`[${index}] port is working`)
    index++
    res.send('hello sagar')
})

app.get('/getPollingStation',authenticateToken,async (req,res)=>{
    // console.log("getting ps")
    try{
        const query = `        
                    SELECT
                    ps.id AS polling_station_id,
                    ps.polling_station,
                    ps.polling_address,
                    t.taluka AS taluka_name,
                    e.full_name AS operator_name
                    FROM
                        polling_stations ps
                    LEFT JOIN
                        taluka t ON ps.taluka = t.id
                    LEFT JOIN
                        employees e ON ps.operator = e.id;
                        
        `;
       
        const { rows } = await pool.query(query);
        res.status(200).json(rows);
    }catch(err){
        res.status(500).json({ error: 'Internal Server Error' });
    }
})



app.post('/registerPollingStation',authenticateToken,async (req,res)=>{
    const {number,operator,address,taluka} = req.body
    try{

        const operator_id = await pool.query('SELECT id FROM employees WHERE full_name = $1',[operator])
        const taluka_id = await pool.query('SELECT id FROM taluka WHERE taluka = $1',[taluka])
       
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


app.post('/registerCamera',authenticateToken,async (req,res)=>{
    const {number,poll_station} = req.body
    const trimmed_poll_station = poll_station.trim();


    try{

        const poll_id = await pool.query('SELECT id FROM polling_stations WHERE polling_station = $1',[trimmed_poll_station])
     
       if (poll_id.rowCount === 0) {
        console.log(`-> Polling station "${poll_station}" not found.`);
        return res.status(404).json({ message: 'Polling station not found', done: false });
        }

        const result = await pool.query(
            `INSERT INTO cameras (serial_number, stream_url, PS, is_active) VALUES ($1, $2, $3, $4) ON CONFLICT (serial_number) DO NOTHING RETURNING serial_number`,
            [number, `rmtp://122.170.240.142:1935/live/${number}`,poll_id.rows[0].id ,false]
        );
        if(result.rows.length > 0){
            const serial_number = result.rows[0].serial_number;
            res.status(201).json({ message: 'Camera registered successfully.', name: serial_number,done:true });
            console.log("$ Camera registered with model name : " + serial_number)
        }
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
        console.log("[+] Taluka registered with name : " + talukaName)
    }catch(e){
        console.log("error occured : "+e)
        res.status(201).json({ message: 'Employee not registered.',done:false });

    }
})


app.post('/login', async (req, res) => {
    const { name, password } = req.body;

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
    console.log(`\n\n\t\t\x1b[37m[+] Apex Live admin server has started on \x1b[36mhttp://localhost:${port}\n\x1b[37m`);
});
