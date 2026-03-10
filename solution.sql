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
