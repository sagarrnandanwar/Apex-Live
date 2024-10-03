const express = require('express');
const pool = require('./database'); 
const { comparePassword } = require('./auth'); 
const app = express();
const port = process.env.ADMIN_PORT;
const { printValue, printLog } = require('./print');
const cors = require('cors')
const jwt = require('jsonwebtoken');
const secretKey='apex_live'

app.use(express.json());
app.use(cors())

async function authUser(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    
    if (!token) {
      return res.status(401).json({ error: 'Token is required' });
    }
     jwt.verify(token, secretKey, async (err, user) => {
        if (err) {
            return res.status(403).json({ error: 'Invalid token'+err });
        }
        next();
    });
}

async function authAdmin(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    
    if (!token) {
      return res.status(401).json({ error: 'Token is required' });
    }
     jwt.verify(token, secretKey, async (err, user) => {
        if (err) {
            return res.status(403).json({ error: 'Invalid token'+err });
        }

        if(user.admin) {
            next();
        }
        else  {
            return res.status(403).json({ error: 'Not authorized' });
        } 
    });
}



app.get('/employees',authUser,async (req, res)=>{

    const firstName = req.query.firstName
    const lastName = req.query.lastName
    const fullName = `${firstName} ${lastName}`;

    try {
        const userList = await pool.query(`SELECT first_name, last_name FROM employees WHERE CONCAT(first_name, ' ', last_name) = $1`,[fullName]);
        console.log(printLog('📨','g','200','employees DB info sent to : ') ,printValue('email', email))
        res.status(200).json({userList:userList.rows});
    }catch (err) {
        console.log(printLog('📨','r','500','employees DB info denied for : ') ,printValue('email', email))
        res.status(500).json({error:"Invalid query parameters"})
    }

})


app.get('/authenticateToken',async (req,res)=>{

    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];    

    if (!token) {
      return res.status(401).json({ error: 'Token is required' });
    }

     jwt.verify(token, secretKey, async (err, user) => {

        if (err) {
            return res.status(403).json({ error: 'Invalid token'+err });
        }
        
        const userInfo = await pool.query('SELECT * FROM employees WHERE id = $1', [user.userId])

        if(userInfo.rows.length > 0) {
            
            console.log(printLog('🔖','g','200','Token is valid'),printValue('email',userInfo.rows[0].email),printValue('admin',userInfo.rows[0].isadmin!=0))
            
            return res.status(200).json({
                auth:true,
                user:userInfo.rows[0],
                admin:userInfo.rows[0].isadmin!=0
            })

        }else return res.status(403).json({error: 'Invalid token'})

    });
})


app.post('/login', async (req, res) => {
    const { email, password } = req.body;


    if (!email || !password) {
        console.log(printLog('➥','r','400','Missing email or password'))
        return res.status(400).json({ error: 'Email and password are required' });
    }

    try {

        const {rows} = await pool.query('SELECT id, hashed_password FROM employees WHERE email = $1',[email])

        if (rows.length === 0) {
            console.log(printLog('➥','r','401','User not found with : ') ,printValue('email', email),printValue('password', password))
            return res.status(401).json({ error: 'Invalid email or password' });
        }

        const hashedPassword = rows[0].hashed_password;
        const isMatch = await comparePassword(password, hashedPassword);

        if (isMatch) {
            const token = jwt.sign({ userId: rows[0].id,admin:(rows[0].isadmin!=0)}, secretKey, { expiresIn: '2h' });
            const userInfo = await pool.query('SELECT * FROM employees WHERE id = $1', [rows[0].id]);
            console.log(printLog('➥','g','200','Login request successful with : '),printValue('email', email),printValue('password',password))
            return res.status(200).json({user:userInfo.rows[0],token:token,admin:userInfo.rows[0].isadmin!=0});
        } else {
            return res.status(401).json({ error: 'Invalid email or password' });
        }
    } catch (err) {
        console.error('Error occurred:', err.message);
        return res.status(500).json({ error: 'Internal Server Error' });
    }
});




app.listen(port, () => {
    console.log(`\n\n\t\t\x1b[37m[⚡️] Apex Live admin server has started on \x1b[36mhttp://localhost:${port}\n\x1b[37m`);
});
