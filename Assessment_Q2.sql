-- ==========================================
-- Question 2: Categorizing transaction frequency
-- Description: Calculate the average number of transactions per customer per month and categorize them
-- Author: Lady Pearl Ampomah Opoku
-- Date: 2025-05-18
-- ==========================================

-- SQL Starts Below

-- CTE to calculate the number of successful transactions per user per month
WITH monthly_transactions AS (
    SELECT 
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m-01') AS month, -- Extract month from date
        COUNT(*) AS transactions_per_month
    FROM savings_savingsaccount
    WHERE transaction_status = 'success'
    GROUP BY owner_id, month
),

-- CTE to compute the average number of monthly transactions per user
avg_transactions AS (
    SELECT 
        owner_id,
        AVG(transactions_per_month) AS avg_transactions_per_month
    FROM monthly_transactions
    GROUP BY owner_id
),

-- CTE to categorize users based on their average transaction frequency
categorized AS (
    SELECT 
        owner_id,
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_transactions_per_month
    FROM avg_transactions
)

-- Main querry to aggregate and report count and average frequency by category
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category
ORDER BY avg_transactions_per_month DESC;
