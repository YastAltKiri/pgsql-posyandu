require('dotenv').config();
const { Pool, types } = require('pg');

// tipe 1082 = DATE, kembalikan sebagai string 'YYYY-MM-DD'
types.setTypeParser(1082, (val) => val);

module.exports = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});