# Year-on-Year-Growth-Rate-SQL-Analytics
Platform: DataLemur · Difficulty: Hard
________________________________________
📌 Problem
Wayfair wants to track how product spending changes over time. Given a table of user transactions, calculate the year-on-year (YoY) growth rate for total spend per product.
Output must include:
•	Year (ascending)
•	Product ID
•	Current year's spend
•	Previous year's spend
•	YoY growth percentage (rounded to 2 decimal places)
________________________________________
🗂️ Schema
user_transactions
Column Name	Type
transaction_id	integer
product_id	integer
spend	decimal
transaction_date	datetime
________________________________________
💡 Example
Input:
transaction_id	product_id	spend	transaction_date
1341	123424	1500.60	12/31/2019
1423	123424	1000.20	12/31/2020
1623	123424	1246.44	12/31/2021
1322	123424	2145.32	12/31/2022
Output:
year	product_id	curr_year_spend	prev_year_spend	yoy_rate
2019	123424	1500.60	NULL	NULL
2020	123424	1000.20	1500.60	-33.35
2021	123424	1246.44	1000.20	24.62
2022	123424	2145.32	1246.44	72.12
________________________________________
✅ Solution
WITH t1 AS (
  SELECT 
    EXTRACT(year FROM transaction_date) AS year,
    product_id,
    spend AS c_y,
    LAG(spend) OVER (
      PARTITION BY product_id 
      ORDER BY EXTRACT(year FROM transaction_date)
    ) AS p_y
  FROM user_transactions
)
SELECT *,
  ROUND(((c_y - p_y) * 100 / p_y), 2) AS yoy_rate
FROM t1;
________________________________________
🧠 Approach & Techniques
Step 1 — Extract year and capture previous year's spend using LAG() The LAG() window function looks back one row within the same product_id partition, ordered by year. This retrieves the previous year's spend without any self-join.
Step 2 — Calculate YoY growth Applied the standard growth formula:
YoY Rate = ((Current Year - Previous Year) / Previous Year) × 100
Wrapped in ROUND(..., 2) for clean output. The first year per product naturally returns NULL since there is no prior row to reference.
Key techniques used:
•	LAG() window function with PARTITION BY and ORDER BY
•	EXTRACT() for date part parsing
•	CTE (WITH) for query readability
•	ROUND() for formatted decimal output
________________________________________
📊 Business Insight
This query powers product performance tracking dashboards — enabling business teams to identify which products are growing, declining, or stagnating year over year, and make data-driven inventory and pricing decisions.
________________________________________
Source: DataLemur · (https://datalemur.com/questions/yoy-growth-rate)
