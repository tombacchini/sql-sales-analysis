-- =====================================
-- SALES ANALYSIS PROJECT
-- PostgreSQL
-- =====================================


-- =====================================
-- 1. Chiffre d'affaires total
-- =====================================

SELECT SUM(net_revenue) AS total_revenue
FROM sales_financial;

-- =====================================
-- 2. Chiffre d'affaires par mois 
-- =====================================

SELECT DATE_TRUNC('month', sale_date) AS month,
       SUM(net_revenue) AS revenue
FROM sales_financial
GROUP BY month
ORDER BY month;

-- =====================================
-- 3. Evolution mensuelle du chiffre d'affaires par rapport au mois précédent 
-- =====================================

WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', sale_date) AS month,
        SUM(net_revenue) AS revenue
    FROM sales_financial
    GROUP BY DATE_TRUNC('month', sale_date)
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
    revenue - LAG(revenue) OVER (ORDER BY month) AS revenue_change
FROM monthly_revenue
ORDER BY month;
-- =====================================
-- 4. Produits les moins rentables 
-- =====================================

SELECT product_name, ROUND(AVG(margin_pct),2) AS avg_margin
FROM sales_financial
GROUP BY product_name
ORDER BY avg_margin ASC
LIMIT 5;
-- =====================================
-- 5. Top 5 Clients 
-- =====================================

SELECT client_name, SUM(net_revenue) AS revenue
FROM sales_financial 
GROUP BY client_name 
ORDER BY revenue DESC 
LIMIT 5;


-- =====================================
-- 6. Clients les plus performants par rapport à la moyenne
-- =====================================

WITH client_revenue AS (
    SELECT
        client_name,
        SUM(net_revenue) AS revenue
    FROM sales_financial
    GROUP BY client_name
)
SELECT
    client_name,
    revenue
FROM client_revenue
WHERE revenue > (
    SELECT AVG(revenue)
    FROM client_revenue
)
ORDER BY revenue DESC;

-- =====================================
-- 7. Part du chiffre d'affaires par région
-- ===================================== 

SELECT
    region,
    SUM(net_revenue) AS revenue,
    ROUND(
        100.0 * SUM(net_revenue) / SUM(SUM(net_revenue)) OVER (),
        2
    ) AS revenue_share_pct
FROM sales_financial
GROUP BY region
ORDER BY revenue DESC;

-- =====================================
-- 8. Performance par catégorie
-- ===================================== 
 	
SELECT
    category,
    SUM(net_revenue) AS revenue,
    SUM(gross_profit) AS profit,
    ROUND(AVG(margin_pct), 2) AS avg_margin
FROM sales_financial
GROUP BY category
ORDER BY revenue DESC;

