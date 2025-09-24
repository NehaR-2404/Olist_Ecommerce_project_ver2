-- ===================================================
-- Creating Tables
-- ===================================================

-- Creating Customers Table
CREATE TABLE customers (
    customer_id VARCHAR PRIMARY KEY,
    customer_unique_id VARCHAR NOT NULL,
    customer_zip_code_prefix INT,
    customer_city VARCHAR,
    customer_state CHAR(2)
);
-- Import the cleaned customers dataset into the customers table.
-- Checking the first five rows for confirmation
SELECT * FROM customers LIMIT 5;

-- Count rows
SELECT COUNT(*) FROM customers;

-- Creating Ordres Table
CREATE TABLE orders (
    order_id VARCHAR PRIMARY KEY,
    customer_id VARCHAR,
    order_status VARCHAR,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date DATE
);

-- Importing the cleaned orders dataset into the orders table
-- Check first few rows
SELECT * FROM orders LIMIT 5;

-- Count rows
SELECT COUNT(*) FROM orders;

-- Creating Order_itmes Table
DROP TABLE IF EXISTS order_items
CREATE TABLE order_items (
    order_id VARCHAR,
    order_item_id INT,
    product_id VARCHAR,
    seller_id VARCHAR,
    last_shipping_date TIMESTAMP,
    price NUMERIC,
    freight_value NUMERIC
);

-- Importing the cleaned order_items dataset into the order_items table
-- Check first few rows
SELECT * FROM order_items LIMIT 5;

-- Count rows
SELECT COUNT(*) FROM order_items;

-- Creating order_payments Table
CREATE TABLE order_payments (
    order_id VARCHAR(50) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value NUMERIC(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);

-- Importing the cleaned order_paymnets dataset into the order_payments table
-- Verifying the data
-- Count rows
SELECT COUNT(*) FROM order_payments;
-- Checking the types of payment
SELECT DISTINCT payment_type FROM order_payments;

-- Creating order_reviews Table
-- Stores reviews for each order along with timestamps and scores

CREATE TABLE order_reviews (
    review_id VARCHAR(50) PRIMARY KEY,            -- Unique ID for each review
    order_id VARCHAR(50) NOT NULL,               -- ID of the order being reviewed
    review_score INT,                            -- Score given by customer (1-5)
    review_comment_title TEXT,                    -- Optional title of the review
    review_comment_message TEXT,                  -- Optional detailed message
    review_creation_date TIMESTAMP,              -- When review was created
    review_answer_timestamp TIMESTAMP             -- When seller answered (if any)
);

-- Importing the cleaned order_reviews dataset into the order_reviews table
-- Preview first 5 rows to ensure data was imported correctly
SELECT * 
FROM order_reviews
LIMIT 5;

-- Count total rows to compare with cleaned CSV
SELECT COUNT(*) AS total_rows
FROM order_reviews;


-- Creating Products Table
DROP TABLE IF EXISTS products
CREATE TABLE products (
    product_id VARCHAR PRIMARY KEY,               -- unique product ID
    product_category_name VARCHAR,                -- category in Portuguese
    product_name_length NUMERIC,                      -- number of characters in product name
    product_description_length NUMERIC,               -- number of characters in description
    product_photos_qty NUMERIC,                       -- number of product photos
    product_weight_g NUMERIC,                         -- weight in grams
    product_length_cm NUMERIC,                        -- package length in cm
    product_height_cm NUMERIC,                        -- package height in cm
    product_width_cm NUMERIC                          -- package width in cm
);

-- Importing cleaned products dataset into the products table
-- Count rows
SELECT COUNT(*) FROM products;

--Creating Sellers Table
CREATE TABLE sellers (
    seller_id VARCHAR PRIMARY KEY,                -- unique seller ID
    seller_zip_code_prefix INT,                   -- first 5 digits of postal code
    seller_city VARCHAR,                          -- seller city
    seller_state VARCHAR                          -- seller state (2-letter code)
);

-- Importing cleaned sellers dataser into sellers table
-- Verifying import
-- Count rows
SELECT COUNT(*) FROM sellers;

-- Creating Geolocation Table
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,              -- zip code prefix
    geolocation_lat NUMERIC,                      -- latitude
    geolocation_lng NUMERIC,                      -- longitude
    geolocation_city VARCHAR,                     -- city
    geolocation_state VARCHAR                     -- state (2-letter code)
    
);

-- Importing cleaned geolocation dataset into the geolocation table
-- Check state
SELECT DISTINCT geolocation_state FROM geolocation;

--Creating Product Category Name Translation Table

CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR PRIMARY KEY,   -- original category name in Portuguese
    product_category_name_english VARCHAR       -- translated category name in English
);

-- Importing product_category_name_translation dataset into the respective table
-- Check top 5 category english names
SELECT product_category_name_english FROM product_category_name_translation
LIMIT 5;

-- ===================================================
-- End of Table Creation
-- All tables created with primary keys and comments
-- Data was also loaded and verified
-- Next step: enforce relationships by adding foreign keys
-- ===================================================

-- ===================================================
-- Enforcing Relationships / Adding Foreign Keys
-- ===================================================

-- orders → customers
-- Each order belongs to one customer.

ALTER TABLE orders
    ADD CONSTRAINT fk_orders_customers
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

--  order_items → orders
--  Each order item belongs to one order.

ALTER TABLE order_items
    ADD CONSTRAINT fk_items_orders
    FOREIGN KEY (order_id) REFERENCES orders(order_id);

-- order_items → products
-- Each order item references one product.

ALTER TABLE order_items
    ADD CONSTRAINT fk_items_product
    FOREIGN KEY (product_id) REFERENCES products(product_id);

-- Create orphan table for order_items referencing missing products because these are issues while establising relationships 
CREATE TABLE order_items_orphan_products AS
SELECT *
FROM order_items
WHERE product_id NOT IN (SELECT product_id FROM products);

-- Remove them from order_items
DELETE FROM order_items
WHERE product_id NOT IN (SELECT product_id FROM products);

--  order_items → sellers
--  Each order item references one seller.

ALTER TABLE order_items
    ADD CONSTRAINT fk_items_sellers
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id);

-- order_payments → orders
ALTER TABLE order_payments
ADD CONSTRAINT fk_pay_orders FOREIGN KEY (order_id) REFERENCES orders(order_id);

-- order_reviews → orders
-- check orphan rows
SELECT COUNT(*) AS orphan_reviews
FROM order_reviews r
WHERE order_id NOT IN (SELECT order_id FROM orders);

-- see details
SELECT order_id, COUNT(*)
FROM order_reviews r
WHERE order_id NOT IN (SELECT order_id FROM orders)
GROUP BY order_id
ORDER BY COUNT(*) DESC;

-- saving them before deleting
CREATE TABLE order_reviews_orphans AS
SELECT *
FROM order_reviews
WHERE order_id NOT IN (SELECT order_id FROM orders);

--Delete from the original table
DELETE FROM order_reviews
WHERE order_id NOT IN (SELECT order_id FROM orders);

--verify cleanup
SELECT COUNT(*)
FROM order_reviews r
WHERE order_id NOT IN (SELECT order_id FROM orders);

--Establishing foreign key constraint

ALTER TABLE order_reviews
ADD CONSTRAINT fk_rev_orders FOREIGN KEY (order_id) REFERENCES orders(order_id);

-- product_category _name_translation → products
ALTER TABLE products
ADD CONSTRAINT fk_prod_cat FOREIGN KEY (product_category_name) 
REFERENCES product_category_name_translation(product_category_name);


/* =========================================================
   ADVANCED SQL ANALYSIS QUERIES
   Dataset: Brazilian E-Commerce Public Dataset (Kaggle)
   Purpose: Generate business insights using window functions,
            CTEs, ranking and advanced joins
   ========================================================= */
   
/* =========================================================
   Question 1: Top 10 customers by total spending 
   Insight: Identifies the highest-value customers for loyalty programs or targeted marketing.
   ========================================================= */

SELECT *
FROM (
    SELECT
        C.customer_unique_id,
        SUM(Oi.price + Oi.freight_value) AS total_spent,
        RANK() OVER (ORDER BY SUM(Oi.price + Oi.freight_value) DESC) AS rank
    FROM orders O
    JOIN order_items Oi
        ON O.order_id = Oi.order_id
    JOIN customers C
        ON O.customer_id = C.customer_id
    GROUP BY C.customer_unique_id
) ranked_customers
WHERE rank <= 10;

/* =========================================================
   Question 2: Top 3 products per category by sales volume 
   Insight: Shows best-selling products in each category to optimize inventory.
   ========================================================= */

SELECT *
FROM (
    SELECT 
        pct.product_category_name_english AS category_name, -- category in English
        oi.product_id,                                     -- product identifier
        COUNT(oi.order_item_id) AS sales_volume,           -- number of units sold
        RANK() OVER (                                     
            PARTITION BY pct.product_category_name_english -- restart ranking for each category
            ORDER BY COUNT(oi.order_item_id) DESC          -- order products by sales volume
        ) AS rank
    FROM order_items oi
    JOIN products p
        ON oi.product_id = p.product_id
    JOIN product_category_name_translation pct
        ON p.product_category_name = pct.product_category_name
    GROUP BY pct.product_category_name_english, oi.product_id
) ranked_products
WHERE rank <= 3                                          -- keep only top 3 per category
ORDER BY category_name, rank;


/* =========================================================
   Question 3: Monthly revenue and month-over-month growth for year 2017
   Insight: Tracks sales trends and seasonal fluctuations.
   Note: Analysis starts from Jan 2017 to avoid sparse 2016 data.
   ========================================================= */

WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', o.order_purchase_timestamp)::date AS month_date, -- month as plain date
        SUM(oi.price + oi.freight_value) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp >= '2017-01-01'       -- ignore sparse 2016 months
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)::date
)
SELECT 
    month_date,
    revenue,
    prev_month_revenue,
    ROUND((revenue - prev_month_revenue) / NULLIF(prev_month_revenue, 0) * 100, 2) AS mom_growth_percent
FROM (
    SELECT 
        month_date,
        revenue,
        LAG(revenue) OVER (ORDER BY month_date) AS prev_month_revenue
    FROM monthly_revenue
) t
WHERE prev_month_revenue IS NOT NULL
ORDER BY month_date;

/* =========================================================
   Question 4: Cumulative revenue per seller over time
   Insight: Measures seller performance and growth trends.
   ========================================================= */

SELECT 
    s.seller_id,
    DATE_TRUNC('month', o.order_purchase_timestamp)::date AS month_date, -- month of order
    SUM(oi.price + oi.freight_value) AS monthly_revenue,                 -- revenue per month
    SUM(SUM(oi.price + oi.freight_value)) OVER (PARTITION BY s.seller_id 
                                               ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)) 
        AS cumulative_revenue                                        -- cumulative revenue per seller
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_id, DATE_TRUNC('month', o.order_purchase_timestamp)
ORDER BY s.seller_id, month_date;

/* =========================================================
   Question 5: Customers with the most orders
   Insight: Identifies loyal and repeat buyers for retention strategies.
   ========================================================= */

SELECT *
FROM (
    SELECT 
        c.customer_unique_id,                     -- unique customer identifier
        COUNT(o.order_id) AS total_orders,       -- total number of orders per customer
        RANK() OVER (ORDER BY COUNT(o.order_id) DESC) AS rank  -- rank customers by number of orders
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
) ranked_customers
WHERE rank <= 10   -- top 10 customers
ORDER BY total_orders DESC;

/* =========================================================
   Question 6: Sellers with highest average product review ratings
   Insight: Highlights top-performing sellers for recognition or incentives.
   ========================================================= */

SELECT *
FROM (
    SELECT 
        s.seller_id,                                 -- seller identifier
        ROUND(AVG(r.review_score),2) AS avg_rating,          -- average review rating
        COUNT(r.review_id) AS review_count,         -- number of reviews per seller
        ROW_NUMBER() OVER (ORDER BY AVG(r.review_score) DESC) AS row_num  -- strict ranking
    FROM sellers s
    JOIN order_items oi
        ON s.seller_id = oi.seller_id
    JOIN order_reviews r
        ON oi.order_id = r.order_id
    GROUP BY s.seller_id
    HAVING COUNT(r.review_id) >= 5                 -- consider only sellers with ≥5 reviews
) ranked_sellers
WHERE row_num <= 10                                -- top 10 sellers
ORDER BY avg_rating DESC;


/* =========================================================
   Question 7: Orders with longest delivery delays
   Insight: Detects fulfillment issues and bottlenecks in delivery.
   ========================================================= */

SELECT *
FROM (
    SELECT 
        o.order_id,                                          -- order identifier
        o.customer_id,                                       -- customer identifier
        o.order_purchase_timestamp::date AS order_date,      -- order placed date
        o.order_delivered_customer_date::date AS delivered_date, -- delivery date
        ROUND(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400,2) AS delivery_days, 
            -- delivery time in days
        RANK() OVER (ORDER BY EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) DESC) AS rank
    FROM orders o
    WHERE o.order_status = 'delivered'                      -- only consider completed deliveries
      AND o.order_delivered_customer_date IS NOT NULL      -- ensure delivered date exists
) ranked_orders
WHERE rank <= 10                                        -- top 10 longest deliveries
ORDER BY delivery_days DESC;


/* =========================================================
   Question 8: Percentage contribution of each item to order total
   Insight: Determines which items dominate order value for pricing or promotions.
   ========================================================= */

SELECT 
    order_id,
    product_id,
    price + freight_value AS item_total,                  -- item total including freight
    SUM(price + freight_value) OVER (PARTITION BY order_id) AS total_order_value,  -- total order value
    ROUND((price + freight_value) / SUM(price + freight_value) OVER (PARTITION BY order_id) * 100, 2) AS pct_of_order
FROM order_items
ORDER BY pct_of_order DESC,total_order_value DESC;

/* =========================================================
   Question 9: Distribution of payment types across all orders
   Insight: Shows customer payment preferences and guides payment strategy.
   ========================================================= */

SELECT 
    payment_type,                                      -- type of payment
    COUNT(*) AS total_orders,                          -- total number of orders for this payment type
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_orders  -- percentage of total orders
FROM order_payments
GROUP BY payment_type
ORDER BY total_orders DESC;

/* =========================================================
   Question 10: Sellers with most consistent monthly sales
   Insight: Identifies reliable sellers for stable supply and forecasting.
   ========================================================= */

WITH monthly_sales AS (
    SELECT
        s.seller_id,
        DATE_TRUNC('month', o.order_purchase_timestamp)::date AS month_date,
        SUM(oi.price + oi.freight_value) AS monthly_revenue
    FROM sellers s
    JOIN order_items oi
        ON s.seller_id = oi.seller_id
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY s.seller_id, DATE_TRUNC('month', o.order_purchase_timestamp)::date
)
SELECT 
    seller_id,
    COUNT(month_date) AS months_with_sales,                 -- number of months with sales
    ROUND(AVG(monthly_revenue), 2) AS avg_monthly_sales,   -- average monthly revenue
    ROUND(STDDEV(monthly_revenue), 2) AS sales_stddev,     -- standard deviation of monthly revenue shows how much a seller’s monthly sales fluctuate
    DENSE_RANK() OVER (ORDER BY STDDEV(monthly_revenue)) AS d_rank -- lower stddev = more consistent
FROM monthly_sales
GROUP BY seller_id
ORDER BY d_rank
LIMIT 20;  -- top 20 most consistent sellers


/* =========================================================
   Question 11: Products generating highest revenue
   Insight: Highlights products with highest revenue for strategic focus.
   ========================================================= */

SELECT *
FROM (
    SELECT 
        oi.product_id,                                      -- product identifier
        pct.product_category_name_english AS product_name,  -- English category name
        SUM(oi.price + oi.freight_value) AS total_revenue,  -- total revenue per product
        COUNT(oi.order_id) AS total_orders,                -- number of orders for this product
        RANK() OVER (ORDER BY SUM(oi.price + oi.freight_value) DESC) AS rank  -- rank by revenue
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    JOIN product_category_name_translation pct
        ON p.product_category_name = pct.product_category_name  -- join to get English name
    WHERE o.order_status = 'delivered'
    GROUP BY oi.product_id, pct.product_category_name_english
) ranked_products
WHERE rank <= 10
ORDER BY total_revenue DESC;

/* =========================================================
   Question 12: Average order value per customer segment (by state)
   Insight: Reveals spending behavior by customer segment to tailor promotions.
   ========================================================= */

WITH order_values AS (
    SELECT 
        o.order_id,                                -- unique order
        c.customer_state,                          -- customer segment (state as a proxy)
        SUM(oi.price + oi.freight_value) AS order_value -- total value of the order
    FROM orders o
    JOIN order_items oi 
        ON o.order_id = oi.order_id                -- link orders with items
    JOIN customers c
        ON o.customer_id = c.customer_id           -- link orders with customers
    WHERE o.order_status = 'delivered'             -- only include completed orders
    GROUP BY o.order_id, c.customer_state          -- group at order level with customer segment
)

SELECT 
    customer_state AS customer_segment,            -- rename state to "customer segment"
    ROUND(AVG(order_value), 2) AS avg_order_value, -- average order value in that segment
    COUNT(order_id) AS total_orders                -- number of orders in that segment
FROM order_values
GROUP BY customer_state
ORDER BY avg_order_value DESC;                     -- rank segments by AOV

/* =========================================================
   Question 13: Customers at risk of churn
   Insight: Identifies inactive customers (no purchases in 
   the last 6 months, relative to dataset end date).
   ========================================================= */
WITH dataset_end AS (
    SELECT MAX(order_purchase_timestamp)::date AS max_date
    FROM orders
),
last_purchase AS (
    SELECT 
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp)::date AS last_order_date  -- most recent order
    FROM customers c
    JOIN orders o 
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'      -- only consider completed orders
    GROUP BY c.customer_unique_id
)
SELECT 
    lp.customer_unique_id,
    lp.last_order_date,
    CASE 
        WHEN lp.last_order_date < (de.max_date - INTERVAL '12 months') 
            THEN 'Potential Churn'
        ELSE 'Active'
    END AS customer_status
FROM last_purchase lp
CROSS JOIN dataset_end de
ORDER BY lp.last_order_date ASC;  -- oldest last orders first (most at risk)

/* =========================================================
   Question 14: Orders containing repeated items
   Insight: Detects unusual buying patterns and potential bulk purchases.
   ========================================================= */

WITH item_counts AS (
    SELECT 
        oi.order_id,
        oi.product_id,
        COUNT(*) AS item_count
    FROM order_items oi
    GROUP BY oi.order_id, oi.product_id
)

SELECT 
    ic.order_id,
    ic.product_id,
    pct.product_category_name_english AS product_category,
    ic.item_count
FROM item_counts ic
JOIN products p
    ON ic.product_id = p.product_id
LEFT JOIN product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
WHERE ic.item_count > 1
ORDER BY ic.item_count DESC;

/* =========================================================
   Question 15: Most frequently purchased product combinations
   Insight: Supports cross-selling and bundle recommendations.
   ========================================================= */
   
SELECT 
    LEAST(oi1.product_id, oi2.product_id) AS product_a,  -- ensure consistent ordering of pairs
    GREATEST(oi1.product_id, oi2.product_id) AS product_b,
    COUNT(*) AS combo_count
FROM order_items oi1
JOIN order_items oi2
    ON oi1.order_id = oi2.order_id
   AND oi1.product_id < oi2.product_id  -- avoid duplicates & self-joins
GROUP BY product_a, product_b
ORDER BY combo_count DESC
LIMIT 10;  -- top 10 combos

/* =========================================================
   Question 16: Category-wise growth trends
   Insight: Measures which product categories are growing fastest for inventory planning.
   ========================================================= */

WITH monthly_category_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp)::date AS month,
        pct.product_category_name_english AS category_name,
        SUM(oi.price + oi.freight_value) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    JOIN product_category_name_translation pct
        ON p.product_category_name = pct.product_category_name
    WHERE o.order_status = 'delivered'
    GROUP BY month, category_name
),
category_growth AS (
    SELECT
        category_name,
        month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (PARTITION BY category_name ORDER BY month) AS prev_month_revenue,
        ROUND(
            (monthly_revenue - LAG(monthly_revenue) OVER (PARTITION BY category_name ORDER BY month))
            / LAG(monthly_revenue) OVER (PARTITION BY category_name ORDER BY month) * 100, 2
        ) AS mom_growth_pct
    FROM monthly_category_revenue
)

SELECT *
FROM category_growth
ORDER BY category_name, month;

/* =========================================================
   Question 17: Average review scores per product category over time
   Insight: Monitors product satisfaction trends and category quality.
   ========================================================= */

WITH product_reviews AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp)::date AS month,
        pct.product_category_name_english AS category_name,
        r.review_score
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN order_reviews r
        ON o.order_id = r.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    JOIN product_category_name_translation pct
        ON p.product_category_name = pct.product_category_name
    WHERE o.order_status = 'delivered'
)
SELECT
    category_name,
    month,
    ROUND(AVG(review_score), 2) AS avg_review_score,
    COUNT(review_score) AS total_reviews
FROM product_reviews
GROUP BY category_name, month
ORDER BY category_name, month;

/* =========================================================
   Question 18: High-value orders with low review scores
   Insight: Detects high-impact customer dissatisfaction for corrective actions.
   ========================================================= */

SELECT DISTINCT
    order_id,
    total_order_value,
    review_score,
    product_category
FROM (
    SELECT
        o.order_id,
        r.review_score,
        pct.product_category_name_english AS product_category,
        SUM(oi.price + oi.freight_value) OVER (PARTITION BY o.order_id) AS total_order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN order_reviews r
        ON o.order_id = r.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    JOIN product_category_name_translation pct
        ON p.product_category_name = pct.product_category_name
    WHERE o.order_status = 'delivered'
) sub
WHERE total_order_value > 500
  AND review_score <= 3
ORDER BY total_order_value DESC, review_score ASC;

/* =========================================================
   Project Summary:
   This analysis of the Olist e-commerce dataset uncovers top customers,
   best-selling products, category growth trends, and high-impact low-review orders.
   Demonstrates advanced SQL skills (window functions, aggregation, ranking) 
   to extract actionable business insights.
*/






