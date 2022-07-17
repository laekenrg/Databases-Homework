const express = require("express");
const cors = require("cors");
const app = express();
const { Pool } = require("pg");

const myLogger = (req, res, next) => {
  const log = {
    date: new Date(),
    url: req.url,
  };
  console.log(JSON.stringify(log, null, 2));
  next();
};

const corsOptions = { origin: "http://localhost:3002" };
app.use(cors(corsOptions));
app.use(myLogger);

const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: "cyf_ecommerce",
  password: "rosado19#",
  port: 5432,
});

app.get("/customers", function (req, res) {
  const customerName = req.query.name;
  let query = `SELECT * FROM customers ORDER BY name`;
  if (customerName) {
    query = `SELECT * FROM customers WHERE name LIKE '%${customerName}%' ORDER BY name`;
  }

  pool
    .query(query)
    .then((result) => res.json(result.rows))
    .catch((e) => console.error(e));
});

app.get("/suppliers", function (req, res) {
  pool.query("SELECT * FROM suppliers", (error, result) => {
    res.json(result.rows);
  });
});

app.get("/products", function (req, res) {
  const productName = req.query.name;
  let query = `
    SELECT product_name, supplier_name 
    FROM products AS p 
    INNER JOIN suppliers AS s ON s.id=supplier_id`;

  if (productName) {
    query = `SELECT * FROM products WHERE product_name LIKE '%${productName}%' ORDER BY product_name`;
  }

  pool
    .query(query)
    .then((result) => res.json(result.rows))
    .catch((e) => console.error(e));
});

app.get("/customers/:customerId", function (req, res) {
  const customerId = req.params.customerId;

  pool
    .query("SELECT * FROM customers WHERE id=$1", [customerId])
    .then((result) => res.json(result.rows))
    .catch((e) => console.error(e));
});

app.get("/customers/:customerId/orders", function (req, res) {
  const customerId = req.params.customerId;

  pool
    .query(
      `
      SELECT order_reference, order_date, product_name, unit_price, supplier_name, quantity
      FROM customers AS c
      INNER JOIN orders AS o ON c.id=o.customer_id
      INNER JOIN order_items AS i ON o.id=i.order_id
      INNER JOIN products AS p ON p.id=i.product_id
      INNER JOIN suppliers AS s ON s.id=p.supplier_id
      WHERE c.id=$1`,
      [customerId]
    )
    .then((result) => res.json(result.rows))
    .catch((e) => console.error(e));
});

app.put("/customers/:customerId", function (req, res) {
  const updateCustomerName = req.body.name;
  const updateCustomerAddress = req.body.address;
  const updateCustomerCity = req.body.city;
  const updateCustomerCountry = req.body.country;
  const updateCustomerID = req.params.customerId;
  const query = `UPDATE customers SET name=$1, address=$2, city=$3, country=$4 WHERE id=$5 RETURNING id`;

  pool
    .query(query, [
      updateCustomerName,
      updateCustomerAddress,
      updateCustomerCity,
      updateCustomerCountry,
      updateCustomerID,
    ])
    .then((result) => res.status(201).json({ customerId: result.rows[0].id }))
    .catch((e) => console.error(e));
});

app.post("/customers", function (req, res) {
  const updateCustomerName = req.body.name;
  const updateCustomerAddress = req.body.address;
  const updateCustomerCity = req.body.city;
  const updateCustomerCountry = req.body.country;
  const updateCustomerID = req.params.customerId;
  const query = `UPDATE customers SET name=$1, address=$2, city=$3, country=$4 WHERE id=$5 RETURNING id`;

  pool
    .query(query, [
      updateCustomerName,
      updateCustomerAddress,
      updateCustomerCity,
      updateCustomerCountry,
      updateCustomerID,
    ])
    .then((result) => res.status(201).json({ customerId: result.rows[0].id }))
    .catch((e) => console.error(e));
});

app.post("/products", function (req, res) {
  const newProductName = req.body.product_name;
  const newProductPrice = req.body.unit_price;
  const newProductSupplierId = req.body.supplier_id;
  const allSupliers = `SELECT * FROM suppliers AS s WHERE s.id=$1`;

  if (!Number.isInteger(newProductPrice) || newProductPrice <= 0) {
    return res.status(400).send("The price should be a positive integer.");
  }

  pool.query(allSupliers, [newProductSupplierId]).then((result) => {
    if (result.rows.length === 0) {
      return res.status(400).send(`Suppliers doesn't exists!`);
    } else {
      const query =
        "INSERT INTO products (product_name, unit_price, supplier_id) VALUES ($1, $2, $3) RETURNING id";
      pool
        .query(query, [newProductName, newProductPrice, newProductSupplierId])
        .then((result) =>
          res.status(201).json({ productId: result.rows[0].id })
        )
        .catch((e) => console.error(e));
    }
  });
});

app.post("/customers/:customerId/orders", function (req, res) {
  const newCustomerName = req.body.name;
  const newCustomerAddress = req.body.address;
  const newCustomerCity = req.body.city;
  const newCustomerCountry = req.body.country;

  pool
    .query("SELECT * FROM customers WHERE address=$1 AND name=$2", [
      newCustomerAddress,
      newCustomerName,
    ])
    .then((result) => {
      if (result.rows.length > 0) {
        return res
          .status(400)
          .send("An user with the same address already exists!");
      } else {
        const query =
          "INSERT INTO customers (name, address, city, country) VALUES ($1, $2, $3, $4) RETURNING id";
        pool
          .query(query, [
            newCustomerName,
            newCustomerAddress,
            newCustomerCity,
            newCustomerCountry,
          ])
          .then((result) =>
            res.status(201).json({ customerId: result.rows[0].id })
          )
          .catch((e) => console.error(e));
      }
    });
});

app.delete("/orders/:orderId", function (req, res) {
  const OrderId = req.params.orderId;
  const query = `SELECT * FROM orders AS o WHERE o.id=$1`;

  pool.query(query, [OrderId]).then((result) => {
    if (result.rows.length === 0) {
      return res.status(400).send("This order doesn't exist!");
    } else {
      pool
        .query("DELETE FROM orders WHERE id=$1", [OrderId])
        .then(() => res.send(`Order ${OrderId} deleted!`))
        .catch((e) => console.error(e));
    }
  });
});

app.delete("/customers/:customerId", function (req, res) {
  const customerId = req.params.customerId;
  const query = `SELECT * FROM orders AS o WHERE o.customer_id=$1`;

  pool.query(query, [customerId]).then((result) => {
    if (result.rows.length > 0) {
      return res.status(400).send("This customer has orders!");
    } else {
      pool
        .query("DELETE FROM customers WHERE id=$1", [customerId])
        .then(() => res.send(`Customer ${customerId} deleted!`))
        .catch((e) => console.error(e));
    }
  });
});

app.listen(3002, function () {
  console.log("Server is listening on port 3002. Ready to accept requests!");
});
