# 📖 Data Dictionary — IndiaKart E-Commerce Database
**Period:** 24-Jun-2023 to 23-Jun-2025

---

## 1. TABLE: `suppliers` (200 records)
| Column | Data Type | Description | Example |
|--------|-----------|-------------|---------|
| supplier_id | VARCHAR(10) | Unique supplier identifier | SUP0001 |
| supplier_name | VARCHAR(100) | Company name of supplier | Sharma Ele Pvt Ltd |
| contact_person | VARCHAR(80) | Primary contact name | Rahul Sharma |
| email | VARCHAR(120) | Business email address | contact@sharmaele.com |
| phone | VARCHAR(15) | 10-digit mobile number | 9812345678 |
| city | VARCHAR(50) | City of operation | Mumbai |
| state | VARCHAR(50) | Indian state | Maharashtra |
| pincode | VARCHAR(10) | 6-digit postal code | 400001 |
| category | VARCHAR(50) | Product category supplied | Electronics |
| gstin | VARCHAR(20) | GST Identification Number | 27AAAAA1234A1Z5 |
| payment_terms_days | INT | Credit period in days | 30 |
| rating | DECIMAL(3,1) | Internal supplier rating (1-5) | 4.2 |
| created_date | DATE | Onboarding date (DD-MM-YYYY) | 15-03-2022 |
| is_active | TINYINT(1) | 1=Active, 0=Inactive | 1 |

---

## 2. TABLE: `products` (1,000 records)
| Column | Data Type | Description | Example |
|--------|-----------|-------------|---------|
| product_id | VARCHAR(10) | Unique product identifier | PRD0001 |
| product_name | VARCHAR(150) | Full product name with variant | Reliance Smartphone Pro |
| category | VARCHAR(50) | Parent category | Electronics |
| subcategory | VARCHAR(80) | Product type | Smartphone |
| brand | VARCHAR(80) | Brand name | Reliance |
| sku | VARCHAR(30) | Stock Keeping Unit code | SKU-ELE-00001 |
| mrp | DECIMAL(10,2) | Maximum Retail Price (₹) | 29999.00 |
| selling_price | DECIMAL(10,2) | Our selling price (₹) | 24999.00 |
| cost_price | DECIMAL(10,2) | Purchase cost from supplier (₹) | 16499.00 |
| gst_rate | INT | GST percentage applicable | 18 |
| hsn_code | VARCHAR(10) | Harmonised System of Nomenclature code | 8517 |
| weight_grams | INT | Product weight in grams | 250 |
| supplier_id | VARCHAR(10) | FK → suppliers | SUP0012 |
| rating | DECIMAL(3,1) | Customer rating (1–5) | 4.3 |
| review_count | INT | Number of customer reviews | 1250 |
| is_active | TINYINT(1) | 1=Listed, 0=Delisted | 1 |
| launch_date | DATE | Date product was listed | 01-07-2023 |

**GST Rates by Category:**
| Category | GST Rate |
|----------|----------|
| Books, Grocery | 0% |
| Fashion | 5% |
| Home & Kitchen, Sports & Fitness, Toys & Baby | 12% |
| Electronics, Beauty & Health, Office Supplies | 18% |
| Automotive | 28% |

---

## 3. TABLE: `inventory` (1,000 records)
| Column | Data Type | Description | Example |
|--------|-----------|-------------|---------|
| inventory_id | VARCHAR(10) | Unique inventory record ID | INV0001 |
| product_id | VARCHAR(10) | FK → products | PRD0001 |
| warehouse_location | VARCHAR(50) | Fulfillment center name | Mumbai-WH1 |
| quantity_available | INT | Current sellable stock | 150 |
| quantity_reserved | INT | Stock reserved for open orders | 12 |
| reorder_level | INT | Minimum qty before reorder trigger | 25 |
| reorder_quantity | INT | Units to order when restocking | 100 |
| last_restocked_date | DATE | Last inventory replenishment date | 10-05-2025 |
| unit_cost | DECIMAL(10,2) | Cost per unit (₹) | 16499.00 |
| total_inventory_value | DECIMAL(12,2) | quantity × unit_cost (₹) | 2474850.00 |
| status | VARCHAR(20) | In Stock / Low Stock / Out of Stock | In Stock |

---

## 4. TABLE: `customers` (10,000 records)
| Column | Data Type | Description | Example |
|--------|-----------|-------------|---------|
| customer_id | VARCHAR(12) | Unique customer ID | CUST00001 |
| first_name | VARCHAR(50) | Indian first name | Rahul |
| last_name | VARCHAR(50) | Indian surname | Sharma |
| email | VARCHAR(120) | Email address | rahul.sharma123@gmail.com |
| phone | VARCHAR(15) | 10-digit mobile number | 9876543210 |
| city | VARCHAR(50) | Delivery city | Bengaluru |
| state | VARCHAR(50) | Indian state | Karnataka |
| pincode | VARCHAR(10) | 6-digit pin code | 560001 |
| gender | VARCHAR(10) | Male / Female / Other | Male |
| age | INT | Age in years | 28 |
| segment | VARCHAR(20) | Customer tier | Premium |
| registration_date | DATE | Account creation date | 15-06-2023 |
| last_login_date | DATE | Most recent app/site login | 20-06-2025 |
| total_orders | INT | Lifetime order count | 12 |
| total_spent | DECIMAL(12,2) | Lifetime GMV from this customer (₹) | 85000.00 |
| is_verified | TINYINT(1) | Phone/email verified | 1 |
| is_active | TINYINT(1) | Account active status | 1 |

**Customer Segments:**
| Segment | Description | Share |
|---------|-------------|-------|
| Regular | 5–20 orders, moderate spend | 40% |
| Budget | Low AOV, price-sensitive | 25% |
| Premium | High AOV, 20+ orders | 15% |
| New | <3 orders | 15% |
| Inactive | No order in 6+ months | 5% |

---

## 5. TABLE: `orders` (50,000 records)
| Column | Data Type | Description | Example |
|--------|-----------|-------------|---------|
| order_id | VARCHAR(12) | Unique order ID | ORD000001 |
| customer_id | VARCHAR(12) | FK → customers | CUST00001 |
| order_date | DATE | Date order placed (DD-MM-YYYY) | 15-10-2024 |
| order_time | TIME | Time of order (IST) | 20:35:00 |
| status | VARCHAR(20) | Delivered/Shipped/Processing/Cancelled/Returned | Delivered |
| city | VARCHAR(50) | Delivery city | Mumbai |
| state | VARCHAR(50) | Delivery state | Maharashtra |
| pincode | VARCHAR(10) | Delivery pincode | 400001 |
| total_amount | DECIMAL(12,2) | Subtotal before shipping (₹) | 15000.00 |
| gst_amount | DECIMAL(10,2) | GST component (₹) | 2700.00 |
| shipping_charge | DECIMAL(8,2) | Delivery fee (₹, 0 if >₹500) | 0.00 |
| discount_amount | DECIMAL(10,2) | Coupon/promotional discount (₹) | 1200.00 |
| final_amount | DECIMAL(12,2) | Amount charged to customer (₹) | 16500.00 |
| payment_method | VARCHAR(30) | UPI/Credit Card/Cash on Delivery/EMI etc. | UPI |
| shipping_partner | VARCHAR(50) | Logistics company | Delhivery |
| tracking_id | VARCHAR(30) | Shipment tracking number | TRK123456789 |
| delivered_date | DATE | Actual delivery date | 18-10-2024 |
| is_cod | TINYINT(1) | 1=Cash on Delivery | 0 |
| channel | VARCHAR(20) | App / Website / Mobile Web | App |

---

## 6. TABLE: `order_items` (100,000 records)
| Column | Data Type | Description | Example |
|--------|-----------|-------------|---------|
| item_id | VARCHAR(12) | Unique line-item ID | ITM0000001 |
| order_id | VARCHAR(12) | FK → orders | ORD000001 |
| product_id | VARCHAR(10) | FK → products | PRD0042 |
| product_name | VARCHAR(150) | Product name at time of order | Tata Laptop Pro |
| category | VARCHAR(50) | Product category | Electronics |
| quantity | INT | Units purchased | 1 |
| unit_price | DECIMAL(10,2) | Price per unit at purchase (₹) | 45000.00 |
| gst_rate | INT | GST % applied | 18 |
| gst_amount | DECIMAL(10,2) | GST charged (₹) | 8100.00 |
| discount_amount | DECIMAL(10,2) | Discount applied on this item (₹) | 2250.00 |
| total_price | DECIMAL(12,2) | Net price paid (₹) | 50850.00 |

---

## 7. TABLE: `payments` (50,000 records)
| Column | Data Type | Description | Example |
|--------|-----------|-------------|---------|
| payment_id | VARCHAR(12) | Unique payment ID | PAY000001 |
| order_id | VARCHAR(12) | FK → orders | ORD000001 |
| customer_id | VARCHAR(12) | FK → customers | CUST00001 |
| payment_date | DATE | Date of payment attempt | 15-10-2024 |
| payment_time | TIME | Time of payment (IST) | 20:35:10 |
| payment_method | VARCHAR(30) | UPI / Credit Card / etc. | UPI |
| amount | DECIMAL(12,2) | Amount attempted/paid (₹) | 16500.00 |
| status | VARCHAR(20) | Success / Failed | Success |
| transaction_id | VARCHAR(30) | Gateway transaction reference | TXN9876543210 |
| bank_name | VARCHAR(60) | Issuing/receiving bank | HDFC Bank |
| gateway | VARCHAR(40) | Payment gateway used | Razorpay |
| refund_amount | DECIMAL(10,2) | Amount refunded (₹) | 0.00 |
| refund_date | DATE | Date refund processed | NULL |

---

## 8. TABLE: `returns` (10,000 records)
| Column | Data Type | Description | Example |
|--------|-----------|-------------|---------|
| return_id | VARCHAR(10) | Unique return request ID | RET00001 |
| order_id | VARCHAR(12) | FK → orders | ORD000123 |
| customer_id | VARCHAR(12) | FK → customers | CUST00045 |
| return_date | DATE | Date return initiated | 22-10-2024 |
| reason | VARCHAR(100) | Return reason | Defective Product |
| return_amount | DECIMAL(12,2) | Amount to be refunded (₹) | 16500.00 |
| refund_status | VARCHAR(20) | Refunded / Pending / Rejected | Refunded |
| refund_date | DATE | Date refund completed | 27-10-2024 |
| return_condition | VARCHAR(20) | Good / Damaged / Acceptable | Good |
| remarks | TEXT | Additional notes | Customer initiated within 7 days |

---

## ER Diagram (Logical Relationships)
```
SUPPLIERS (1) ─────────────── (M) PRODUCTS
                                    │
                               (1)──┤
                                    │
INVENTORY (1:1) ───────────── PRODUCTS
                                    │
                               (M)──┤
                                    │
CUSTOMERS (1) ─────────────── (M) ORDERS ─── (M) ORDER_ITEMS (M) ─── (1) PRODUCTS
                │                   │
                │              (1:1)─┤
                │                   │
                └──────────── (M) PAYMENTS
                │
                └──────────── (M) RETURNS ─── (1) ORDERS
```

---

## Recommended Indexes Summary
| Table | Index Column(s) | Reason |
|-------|-----------------|--------|
| orders | order_date | Monthly trend queries |
| orders | status | Fulfillment filtering |
| orders | customer_id | Customer 360 |
| orders | state | Geo analytics |
| order_items | order_id | Order details join |
| order_items | product_id | Product performance |
| order_items | category | Category dashboard |
| customers | segment | Segment analysis |
| payments | payment_date | Revenue reporting |
| payments | gateway | Gateway analytics |

