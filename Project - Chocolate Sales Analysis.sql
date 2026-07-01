-- Check Available Discount Levels
SELECT DISTINCT discount FROM `project-499421.Data.Sales`;

-- Check Customer Age Range
SELECT MIN(age) AS min_age, MAX(age) AS max_age FROM `project-499421.Data.Customers`;

-- Check Loyalty Member
SELECT DISTINCT loyalty_member FROM `project-499421.Data.Customers`;

-- Create Joined Dataset
CREATE OR REPLACE TABLE `project-499421.Data.join_table` AS
WITH sales_cte AS (
    SELECT order_id, order_date, product_id, store_id, customer_id, quantity, unit_price, discount, revenue, cost, profit,
        CASE
            WHEN discount = 0 THEN 'No Discount (0%)'
            WHEN discount = 0.10 THEN 'Low Discount (10%)'
            WHEN discount = 0.15 THEN 'Medium Discount (15%)'
            WHEN discount = 0.20 THEN 'High Discount (20%)'
        END AS discount_group,
    FROM `project-499421.Data.Sales`
),
customers_cte AS (
    SELECT customer_id, age, gender, loyalty_member, join_date,
        CASE
            WHEN age < 20 THEN 'Under 20'
            WHEN age BETWEEN 20 AND 29 THEN '20-29'
            WHEN age BETWEEN 30 AND 39 THEN '30-39'
            WHEN age BETWEEN 40 AND 49 THEN '40-49'
            ELSE '50+'
        END AS age_group,
        CASE
            WHEN loyalty_member = 1 THEN 'Member'
            ELSE 'Non Member'
        END AS membership_status
    FROM `project-499421.Data.Customers`
)
SELECT s.order_id, s.order_date, s.product_id, s.store_id, s.customer_id, s.quantity, s.unit_price, s.discount,s.discount_group, s.revenue, s.cost, s.profit,
    p.product_name, p.brand, p.category,
    st.string_field_1 AS store_name, st.string_field_2 AS city, st.string_field_3 AS country, st.string_field_4 AS store_type,
    c.age, c.age_group, c.gender,c.loyalty_member,c.membership_status, c.join_date,
    cal.year, cal.month, cal.day, cal.week, cal.day_of_week
FROM sales_cte s
LEFT JOIN `project-499421.Data.Products` p ON s.product_id = p.product_id
LEFT JOIN `project-499421.Data.Stores` st ON s.store_id = st.string_field_0
LEFT JOIN customers_cte c ON s.customer_id = c.customer_id
LEFT JOIN `project-499421.Data.Calendar` cal ON s.order_date = cal.date;


-- Data Cleaning
-- Check Duplicate Data
SELECT order_id, COUNT(*) AS jumlah_duplikat
FROM `project-499421.Data.join_table`
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Check Missing Values
SELECT * FROM `project-499421.Data.join_table`
WHERE order_id IS NULL
OR order_date IS NULL
OR product_id IS NULL
OR store_id IS NULL
OR customer_id IS NULL
OR quantity IS NULL 
OR unit_price IS NULL
OR discount IS NULL
OR discount_group IS NULL
OR revenue IS NULL
OR cost IS NULL
OR profit IS NULL
OR product_name IS NULL
OR brand IS NULL
OR category IS NULL
OR store_name IS NULL 
OR city IS NULL 
OR country IS NULL
OR store_type IS NULL
OR age IS NULL
OR age_group IS NULL
OR gender IS NULL
OR loyalty_member IS NULL
OR membership_status IS NULL
OR join_date IS NULL
OR year IS NULL
OR month IS NULL
OR day IS NULL
OR week IS NULL
OR day_of_week IS NULL;

-- Identify Missing Values
SELECT product_id, COUNT(*) AS total_null
FROM `project-499421.Data.join_table`
WHERE product_name IS NULL
GROUP BY product_id;

-- Create Clean Dataset
CREATE OR REPLACE TABLE `project-499421.Data.join_table_clean` AS
SELECT * FROM `project-499421.Data.join_table`
WHERE product_name IS NOT NULL;

-- Recheck Duplicate Data
SELECT order_id, COUNT(*) AS jumlah_duplikat
FROM `project-499421.Data.join_table_clean`
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Recheck Missing Values
SELECT * FROM `project-499421.Data.join_table_clean`
WHERE order_id IS NULL
OR order_date IS NULL
OR product_id IS NULL
OR store_id IS NULL
OR customer_id IS NULL
OR quantity IS NULL 
OR unit_price IS NULL
OR discount IS NULL
OR discount_group IS NULL
OR revenue IS NULL
OR cost IS NULL
OR profit IS NULL
OR product_name IS NULL
OR brand IS NULL
OR category IS NULL
OR store_name IS NULL 
OR city IS NULL 
OR country IS NULL
OR store_type IS NULL
OR age IS NULL
OR age_group IS NULL
OR gender IS NULL
OR loyalty_member IS NULL
OR membership_status IS NULL
OR join_date IS NULL
OR year IS NULL
OR month IS NULL
OR day IS NULL
OR week IS NULL
OR day_of_week IS NULL;