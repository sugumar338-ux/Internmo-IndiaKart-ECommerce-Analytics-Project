-- ============================================================
-- Company: IndiaKart E-Commerce Marketplace
-- Period: 24-Jun-2023 to 23-Jun-2025
-- ============================================================

-- ============================================================
-- SECTION 1: CREATE TABLE STATEMENTS (MySQL / PostgreSQL)
-- ============================================================

CREATE TABLE suppliers (
    supplier_id       VARCHAR(10)    PRIMARY KEY,
    supplier_name     VARCHAR(100)   NOT NULL,
    contact_person    VARCHAR(80),
    email             VARCHAR(120),
    phone             VARCHAR(15)    NOT NULL,
    city              VARCHAR(50),
    state             VARCHAR(50),
    pincode           VARCHAR(10),
    category          VARCHAR(50),
    gstin             VARCHAR(20),
    payment_terms_days INT,
    rating            DECIMAL(3,1),
    created_date      DATE,
    is_active         TINYINT(1)     DEFAULT 1
);

CREATE TABLE products (
    product_id        VARCHAR(10)    PRIMARY KEY,
    product_name      VARCHAR(150)   NOT NULL,
    category          VARCHAR(50)    NOT NULL,
    subcategory       VARCHAR(80),
    brand             VARCHAR(80),
    sku               VARCHAR(30)    UNIQUE,
    mrp               DECIMAL(10,2)  NOT NULL,
    selling_price     DECIMAL(10,2)  NOT NULL,
    cost_price        DECIMAL(10,2),
    gst_rate          INT            DEFAULT 18,
    hsn_code          VARCHAR(10),
    weight_grams      INT,
    supplier_id       VARCHAR(10),
    rating            DECIMAL(3,1),
    review_count      INT            DEFAULT 0,
    is_active         TINYINT(1)     DEFAULT 1,
    launch_date       DATE,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE inventory (
    inventory_id          VARCHAR(10)  PRIMARY KEY,
    product_id            VARCHAR(10)  NOT NULL,
    warehouse_location    VARCHAR(50),
    quantity_available    INT          DEFAULT 0,
    quantity_reserved     INT          DEFAULT 0,
    reorder_level         INT,
    reorder_quantity      INT,
    last_restocked_date   DATE,
    unit_cost             DECIMAL(10,2),
    total_inventory_value DECIMAL(12,2),
    status                VARCHAR(20),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE customers (
    customer_id        VARCHAR(12)   PRIMARY KEY,
    first_name         VARCHAR(50)   NOT NULL,
    last_name          VARCHAR(50)   NOT NULL,
    email              VARCHAR(120)  UNIQUE,
    phone              VARCHAR(15),
    city               VARCHAR(50),
    state              VARCHAR(50),
    pincode            VARCHAR(10),
    gender             VARCHAR(10),
    age                INT,
    segment            VARCHAR(20),
    registration_date  DATE,
    last_login_date    DATE,
    total_orders       INT           DEFAULT 0,
    total_spent        DECIMAL(12,2) DEFAULT 0.00,
    is_verified        TINYINT(1)    DEFAULT 0,
    is_active          TINYINT(1)    DEFAULT 1,
    INDEX idx_segment (segment),
    INDEX idx_city (city),
    INDEX idx_state (state)
);

CREATE TABLE orders (
    order_id           VARCHAR(12)   PRIMARY KEY,
    customer_id        VARCHAR(12)   NOT NULL,
    order_date         DATE          NOT NULL,
    order_time         TIME,
    status             VARCHAR(20)   NOT NULL,
    city               VARCHAR(50),
    state              VARCHAR(50),
    pincode            VARCHAR(10),
    total_amount       DECIMAL(12,2),
    gst_amount         DECIMAL(10,2),
    shipping_charge    DECIMAL(8,2)  DEFAULT 0,
    discount_amount    DECIMAL(10,2) DEFAULT 0,
    final_amount       DECIMAL(12,2) NOT NULL,
    payment_method     VARCHAR(30),
    shipping_partner   VARCHAR(50),
    tracking_id        VARCHAR(30),
    delivered_date     DATE,
    is_cod             TINYINT(1)    DEFAULT 0,
    channel            VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    INDEX idx_order_date (order_date),
    INDEX idx_status (status),
    INDEX idx_customer (customer_id),
    INDEX idx_state (state)
);

CREATE TABLE order_items (
    item_id            VARCHAR(12)   PRIMARY KEY,
    order_id           VARCHAR(12)   NOT NULL,
    product_id         VARCHAR(10)   NOT NULL,
    product_name       VARCHAR(150),
    category           VARCHAR(50),
    quantity           INT           NOT NULL DEFAULT 1,
    unit_price         DECIMAL(10,2) NOT NULL,
    gst_rate           INT,
    gst_amount         DECIMAL(10,2),
    discount_amount    DECIMAL(10,2) DEFAULT 0,
    total_price        DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    INDEX idx_order_id   (order_id),
    INDEX idx_product_id (product_id),
    INDEX idx_category   (category)
);

CREATE TABLE payments (
    payment_id         VARCHAR(12)   PRIMARY KEY,
    order_id           VARCHAR(12)   NOT NULL,
    customer_id        VARCHAR(12)   NOT NULL,
    payment_date       DATE          NOT NULL,
    payment_time       TIME,
    payment_method     VARCHAR(30),
    amount             DECIMAL(12,2) NOT NULL,
    status             VARCHAR(20),
    transaction_id     VARCHAR(30)   UNIQUE,
    bank_name          VARCHAR(60),
    gateway            VARCHAR(40),
    refund_amount      DECIMAL(10,2) DEFAULT 0,
    refund_date        DATE,
    FOREIGN KEY (order_id)    REFERENCES orders(order_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    INDEX idx_payment_date (payment_date),
    INDEX idx_status       (status),
    INDEX idx_gateway      (gateway)
);

CREATE TABLE returns (
    return_id          VARCHAR(10)   PRIMARY KEY,
    order_id           VARCHAR(12)   NOT NULL,
    customer_id        VARCHAR(12)   NOT NULL,
    return_date        DATE          NOT NULL,
    reason             VARCHAR(100),
    return_amount      DECIMAL(12,2),
    refund_status      VARCHAR(20),
    refund_date        DATE,
    return_condition   VARCHAR(20),
    remarks            TEXT,
    FOREIGN KEY (order_id)    REFERENCES orders(order_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    INDEX idx_return_date  (return_date),
    INDEX idx_refund_status (refund_status)
);


-- ============================================================
-- SECTION 2: KEY BUSINESS KPI QUERIES
-- ============================================================

-- 1. Monthly Revenue Trend (GMV)
SELECT
    DATE_FORMAT(STR_TO_DATE(order_date,'%d-%m-%Y'), '%Y-%m') AS month,
    COUNT(order_id)              AS total_orders,
    SUM(final_amount)            AS gross_revenue_inr,
    SUM(gst_amount)              AS total_gst_collected,
    SUM(discount_amount)         AS total_discounts,
    AVG(final_amount)            AS avg_order_value,
    SUM(CASE WHEN status='Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders
FROM orders
GROUP BY 1 ORDER BY 1;

-- 2. Category-wise Sales Performance
SELECT
    oi.category,
    COUNT(DISTINCT oi.order_id)          AS orders,
    SUM(oi.quantity)                     AS units_sold,
    SUM(oi.total_price)                  AS revenue_inr,
    ROUND(SUM(oi.total_price)*100.0/
          (SELECT SUM(total_price) FROM order_items),2) AS revenue_share_pct,
    AVG(oi.unit_price)                   AS avg_selling_price,
    SUM(oi.gst_amount)                   AS gst_collected
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status NOT IN ('Cancelled')
GROUP BY 1 ORDER BY revenue_inr DESC;

-- 3. Customer Segment Analysis (RFM-style)
SELECT
    c.segment,
    COUNT(c.customer_id)           AS customer_count,
    AVG(c.total_orders)            AS avg_orders,
    AVG(c.total_spent)             AS avg_lifetime_value_inr,
    SUM(c.total_spent)             AS segment_revenue_inr,
    ROUND(AVG(c.age),1)            AS avg_age
FROM customers c
GROUP BY c.segment
ORDER BY avg_lifetime_value_inr DESC;

-- 4. Payment Method Distribution
SELECT
    payment_method,
    COUNT(*)                    AS transactions,
    SUM(amount)                 AS total_amount_inr,
    ROUND(AVG(amount),2)        AS avg_transaction_value,
    SUM(CASE WHEN status='Failed' THEN 1 ELSE 0 END) AS failed_count,
    ROUND(100.0*SUM(CASE WHEN status='Failed' THEN 1 ELSE 0 END)/COUNT(*),2) AS failure_rate_pct
FROM payments
GROUP BY payment_method ORDER BY transactions DESC;

-- 5. Return Rate by Category
SELECT
    oi.category,
    COUNT(DISTINCT r.return_id)                            AS returns,
    COUNT(DISTINCT oi.order_id)                            AS orders,
    ROUND(100.0*COUNT(DISTINCT r.return_id)/COUNT(DISTINCT oi.order_id),2) AS return_rate_pct,
    SUM(r.return_amount)                                   AS return_value_inr
FROM order_items oi
LEFT JOIN returns r ON oi.order_id = r.order_id
GROUP BY 1 ORDER BY return_rate_pct DESC;

-- 6. Top 10 Products by Revenue
SELECT
    p.product_id, p.product_name, p.category, p.brand,
    SUM(oi.quantity)       AS units_sold,
    SUM(oi.total_price)    AS revenue_inr,
    AVG(p.rating)          AS product_rating
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Delivered'
GROUP BY 1,2,3,4
ORDER BY revenue_inr DESC LIMIT 10;

-- 7. State-wise Revenue Map
SELECT
    state,
    COUNT(DISTINCT customer_id)  AS customers,
    COUNT(order_id)              AS orders,
    SUM(final_amount)            AS revenue_inr,
    AVG(final_amount)            AS aov_inr
FROM orders
WHERE status='Delivered'
GROUP BY state ORDER BY revenue_inr DESC;

-- 8. Inventory Health Check
SELECT
    i.warehouse_location,
    i.status,
    COUNT(*)                       AS product_count,
    SUM(i.quantity_available)      AS total_units,
    SUM(i.total_inventory_value)   AS inventory_value_inr,
    COUNT(CASE WHEN i.quantity_available < i.reorder_level THEN 1 END) AS below_reorder
FROM inventory i
GROUP BY 1,2 ORDER BY 1,2;

-- 9. Supplier Performance
SELECT
    s.supplier_id, s.supplier_name, s.category,
    COUNT(p.product_id)            AS products_supplied,
    AVG(p.rating)                  AS avg_product_rating,
    s.rating                       AS supplier_rating,
    s.payment_terms_days
FROM suppliers s
JOIN products p ON s.supplier_id = p.supplier_id
GROUP BY 1,2,3,6,7
ORDER BY avg_product_rating DESC;

-- 10. Cohort: New Customers by Month
SELECT
    DATE_FORMAT(STR_TO_DATE(registration_date,'%d-%m-%Y'), '%Y-%m') AS cohort_month,
    COUNT(customer_id)  AS new_customers,
    segment,
    SUM(total_orders)   AS orders_placed,
    SUM(total_spent)    AS revenue_inr
FROM customers
GROUP BY cohort_month, segment
ORDER BY cohort_month;

-- 11. Channel Performance
SELECT
    channel,
    COUNT(order_id)      AS orders,
    SUM(final_amount)    AS revenue_inr,
    AVG(final_amount)    AS avg_order_value,
    SUM(CASE WHEN status='Cancelled' THEN 1 ELSE 0 END)*100.0/COUNT(*) AS cancel_rate
FROM orders
GROUP BY channel ORDER BY revenue_inr DESC;

-- 12. Festive Season Sales (Oct-Nov Diwali Window)
SELECT
    YEAR(STR_TO_DATE(order_date,'%d-%m-%Y'))  AS year,
    MONTH(STR_TO_DATE(order_date,'%d-%m-%Y')) AS month,
    COUNT(order_id)   AS orders,
    SUM(final_amount) AS revenue_inr
FROM orders
WHERE MONTH(STR_TO_DATE(order_date,'%d-%m-%Y')) IN (10,11)
GROUP BY 1,2 ORDER BY 1,2;

