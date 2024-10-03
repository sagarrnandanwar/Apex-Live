const pool = require('./database');

async function getRows(query, input) {
    try {
        // Check if the query and input are valid
        if (!query || (input && !Array.isArray(input))) {
            throw new Error("Invalid query or input parameters");
        }

        // Execute the query
        const result = await pool.query(query, input);

        // Check if the result has rows
        if (!result || !result.rows) {
            throw new Error("Query did not return rows");
        }

        // Return rows
        return result.rows;

    } catch (err) {
        // Log detailed error
        console.error("Error encountered:", err);
        return []; // Return an empty array or handle it appropriately
    }
}

module.exports = getRows;
