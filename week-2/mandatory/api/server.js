const express = require('express');
const cors = require('cors');
const app = express();
const { Pool } = require('pg');

const myLogger = (req, res, next) => {
    const log = {
    date: new Date(),
    url: req.url
};
console.log(JSON.stringify(log, null, 2));
next();
};

const corsOptions = { origin: 'http://localhost:3002' };
app.use(cors(corsOptions));
app.use(myLogger);

const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'cyf_ecommerce',
    password: 'rosado19#',
    port: 5432
});

app.get('/customers', function(req, res) {
    pool.query('SELECT * FROM customers', (error, result) => {
        res.json(result.rows);
    });
});
app.get('/suppliers', function(req, res) {
    pool.query('SELECT * FROM suppliers', (error, result) => {
        res.json(result.rows);
    });
});
app.get('/products', function(req, res) {
    const products = `
    SELECT product_name, supplier_name 
    FROM products AS p 
    INNER JOIN suppliers AS s ON s.id=supplier_id`;
    pool.query(products, (error, result) => {
        res.json(result.rows);
    });
});

app.listen(3002, function() {
    console.log("Server is listening on port 3002. Ready to accept requests!");
});