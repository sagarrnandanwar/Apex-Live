const bcrypt = require('bcrypt');

async function hashPassword(password) {
    const saltRounds = 5; 
    try {
        const hashedPassword = await bcrypt.hash(password, saltRounds);
        console.log('Hashed Password:', hashedPassword)
        return hashedPassword;
    } catch (error) {
        console.error('Error hashing password:', error);
        throw error;
    }
}

async function comparePassword(password, hashedPassword) {
    try {
        const match = await bcrypt.compare(password.toString(), hashedPassword.toString());
        return match;
    } catch (error) {
        console.error('Error comparing password:', error);
        throw error;
    }
}

module.exports = {
    hashPassword,
    comparePassword,
};


// console.log(hashPassword('zish'))