<h1>📊 Retail Database Sales Analysis (MySQL)       </h1>

 <h2> 2. Project Overview / Introduction</h2>
        
This project involves a deep dive into a retail database (`muwanwaa_db`) using MySQL. 
The primary objective is to extract meaningful insights from sales, customer, and product data to understand key business performance indicators, identify trends, and support data-driven decision-making. This analysis covers data cleaning, exploratory data analysis, and advanced SQL querying techniques.

<h2> 3. Data Source / Schema  </h2> 
Data Source:
The dataset for this project is a hypothetical `retail_db` database, provided as a MySQL dump (`queryingdata3scripts.sql`). It simulates a basic e-commerce transaction system.

Database Schema Overview:The database consists of the following key tables:

* `categories`: Stores information about product categories.
    * `category_id` (PK)
    * `category_name`
    * `category_department_id` (FK to `departments` )
* `customers`: Contains customer demographic and contact information.
    * `customer_id` (PK)
    * `customer_fname`, `customer_lname`
    * `customer_email`, `customer_password` 
    * `customer_city`, `customer_state`, `customer_zipcode`
* `orders`: Details about customer orders.
    * `order_id` (PK)
    * `order_date`
    * `order_customer_id` (FK to `customers`)
    * `order_status`
* `products`: Information about individual products.
    * `product_id` (PK)
    * `product_category_id` (FK to `categories`)
    * `product_name`, `product_price`
* `order_items`: Line-item details for each order.
    * `order_item_id` (PK)
    * `order_item_order_id` (FK to `orders`)
    * `order_item_product_id` (FK to `products`)
    * `order_item_quantity`, `order_item_subtotal`
 
  <h2> 4. Tools & Technologies </h2>
* **Database:** MySQL
* **Querying:** MySQL Workbench, Jupyter Notebooks (with `ipython-sql` and `SQLAlchemy`)

  <h2> 5. Data Cleaning & Preparation</h2>

Before analysis, the following data quality aspects were addressed:
* **Redacted Data:** Noted that `customer_email` and `customer_password` columns contained `XXXXXXXXX` values and were excluded from direct analytical use.
* **Duplicate Customer Names:** Investigated highly duplicated `customer_fname` and `customer_lname` combinations (e.g., "Mary Smith"). Determined these likely represent synthetic data entries rather than true unique customers based on consistency in other fields. Analysis proceeded on unique `customer_id`s.
* **Null Values:** Verified database schema's `NOT NULL` constraints, confirming no explicit `NULL` values in key analytical columns. `XXXXXXXXX` in redacted fields were treated as placeholder strings, not nulls.

<h2>6. Key Analysis Questions & Insights</h2>
The project focused on answering several key business questions:

1.  **Customer Demographics:** *Where are our customers located?*
    * **Insight:** A significant portion of customers are concentrated in 'Caguas, PR', indicating either a high market penetration in that area or the presence of placeholder data. Further investigation would be needed.

2.  **Product Category Performance:** *What are the top-selling product categories by revenue?*
    * **Insight:** [Electronics] and [Sports & Outdoors] emerged as the top revenue-generating categories, suggesting strong market demand in these areas.

3.  **Customer Engagement:** *Who are the most active customers, and what is the average number of orders per customer?*
    * **Insight:** Identified the top 10 customers by order volume. The average customer places X orders, providing a baseline for engagement.

4.  **Sales Trends:** *How has overall revenue changed month-over-month?*
    * **Insight:** Observed a consistent growth trend in revenue over the analyzed period, with July of 2013 recording the highest number of revenue.



<h2>Future Work</h2>

* Integrate actual customer contact information (if available) for more robust customer segmentation.
* Perform cohort analysis to understand customer lifetime value.
* Build a predictive model for customer churn or sales forecasting.
