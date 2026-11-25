-- 1. Global KPIs - how many customers and how much capital is lost due to churn?
SELECT
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage,
    ROUND(SUM(balance), 0) AS total_balance,
    ROUND(SUM(CASE WHEN churn = 1 THEN balance ELSE 0 END), 0) AS churned_balance,
    ROUND(SUM(CASE WHEN churn = 1 THEN balance ELSE 0 END) * 100.0 / SUM(balance), 2) AS churned_balance_percentage
FROM customers;


-- 2. Age group vs churn - which age groups leave the most?
SELECT
    age_group,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM customers
GROUP BY age_group
ORDER BY churn_rate_percentage DESC;


-- 3. Activity vs churn - how does customer activity relate to churn?
SELECT
    active_member,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM customers
GROUP BY active_member
ORDER BY churn_rate_percentage DESC;


-- 4. Balance segment vs churn - how does customer balance relate to churn?
-- Segments are created in Python (processing_data.py): zero balance + 3 equal-sized groups
SELECT
    balance_segment,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM customers
GROUP BY balance_segment
ORDER BY churn_rate_percentage DESC;


-- 5. Number of products vs churn - does the number of products matter?
SELECT
    products_number,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM customers
GROUP BY products_number
ORDER BY products_number;


-- 6. Age group and activity together - which combinations are the riskiest?
SELECT
    age_group,
    active_member,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM customers
GROUP BY age_group, active_member
ORDER BY churn_rate_percentage DESC;


-- 7. Country churn compared to the bank's average
-- The CTE calculates the overall churn rate once, then we compare each country to it
WITH overall AS (
    SELECT AVG(churn) * 100 AS overall_churn_rate
    FROM customers
)
SELECT
    c.country,
    COUNT(*) AS total_customers,
    ROUND(AVG(c.churn) * 100, 2) AS churn_rate_percentage,
    ROUND(AVG(c.churn) * 100 - o.overall_churn_rate, 2) AS difference_vs_average,
    RANK() OVER (ORDER BY AVG(c.churn) DESC) AS churn_rank
FROM customers AS c
CROSS JOIN overall AS o
GROUP BY c.country
ORDER BY churn_rank;