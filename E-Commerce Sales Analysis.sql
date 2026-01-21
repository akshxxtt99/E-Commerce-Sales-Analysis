Create Database Ecommerce;
Use Ecommerce;

Create Table Customers(
Customer_id Int Primary Key,
Customer_Name Varchar(50),
City Varchar(50)
);

Create Table Products(
Product_id int Primary Key,
Product_Name Varchar (100),
Category varchar(50),
Price Decimal (10,2)
);

Create Table Orders (
Order_id Int Primary Key,
Customer_id int,
Order_date Date,
Foreign Key (Customer_id) references Customers (Customer_id)
);

Create Table Order_Items (
Order_item_id Int Primary Key,
Order_id int,
Product_id Int,
Quantity Int,
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers VALUES
(1,'Amit','Delhi'),
(2,'Rohit','Mumbai'),
(3,'Neha','Bangalore'),
(4,'Anjali','Pune'),
(5,'Karan','Delhi');

INSERT INTO products VALUES
(101,'Laptop','Electronics',55000),
(102,'Headphones','Electronics',2000),
(103,'Office Chair','Furniture',7000),
(104,'Smartphone','Electronics',25000),
(105,'Water Bottle','Accessories',500);

INSERT INTO orders VALUES
(1001,1,'2024-01-10'),
(1002,2,'2024-01-15'),
(1003,1,'2024-02-05'),
(1004,3,'2024-02-12'),
(1005,4,'2024-03-01');

INSERT INTO order_items VALUES
(1,1001,101,1),
(2,1001,102,2),
(3,1002,103,1),
(4,1003,104,1),
(5,1003,105,3),
(6,1004,102,1),
(7,1005,105,5);

-- Total Revenue--

Select
    Sum(Oi.Quantity* p.price) As TotalRevenue
    From Order_items oi
    Join Products p on oi.product_id = p.product_id;

-- 2. Monthly Revenue Trend
SELECT 
    DATE_FORMAT(o.order_date,'%Y-%m') AS month,
    SUM(oi.quantity * p.price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY month
ORDER BY month;

-- 3. Top 3 Customers by Spending
SELECT 
    c.customer_name,
    SUM(oi.quantity * p.price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 3;

-- 4. Best Selling Products
SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC;

-- 5. Revenue by Category
SELECT 
    p.category,
    SUM(oi.quantity * p.price) AS category_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category;

-- 6. Customer Ranking by Spend
SELECT 
    c.customer_name,
    SUM(oi.quantity * p.price) AS total_spent,
    RANK() OVER (ORDER BY SUM(oi.quantity * p.price) DESC) AS rank_position
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_name;

-- 7. Repeat Customers
SELECT 
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) > 1;

-- 8. Orders Above Average Order Value
SELECT 
    o.order_id,
    SUM(oi.quantity * p.price) AS order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY o.order_id
HAVING order_value >
    (SELECT AVG(order_total) FROM (
        SELECT 
            SUM(oi.quantity * p.price) AS order_total
        FROM order_items oi
        JOIN products p ON oi.product_id = p.product_id
        GROUP BY oi.order_id
    ) avg_orders);

-- 9. Revenue by City
SELECT 
    c.city,
    SUM(oi.quantity * p.price) AS city_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.city
ORDER BY city_revenue DESC;

-- 10. Inactive Customers
SELECT 
    c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


