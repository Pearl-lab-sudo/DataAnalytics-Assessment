-- ==========================================
-- Question 4: [Estimating customer lifetime value (CLV)]
-- Description: [For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
				-- Account tenure (months since signup)
				-- Total transactions
				-- Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
				-- Order by estimated CLV from highest to lowest]
-- Author: Lady Pearl Ampomah Opoku
-- Date: 2025-05-18
-- ==========================================

-- SQL Starts Below

-- CTE to summarize inflow transactions per customer
WITH transaction_summary AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_transactions,
        SUM(confirmed_amount * 0.001) AS total_profit,
        AVG(confirmed_amount * 0.001) AS avg_profit_per_transaction
    FROM savings_savingsaccount
    WHERE transaction_status IN ('success', 'reward') 
    GROUP BY owner_id
),

-- CTE to calculate account tenure (in months) for each user
user_tenure AS (
    SELECT 
        id AS customer_id,
        CONCAT(first_name, ' ', last_name) AS name,
        TIMESTAMPDIFF(MONTH, date_joined, CURDATE()) AS tenure_months
    FROM users_customuser
)

-- Main querry to combine transaction data and tenure to estimate CLV
SELECT 
    u.customer_id,
    u.name,
    u.tenure_months,
    
    -- Handle users who may have no transactions using COALESCE
    COALESCE(t.total_transactions, 0) AS total_transactions,
    
    -- CLV formula: (total_txns / tenure) * 12 months * avg_profit_per_txn
    ROUND(
        CASE 
            WHEN u.tenure_months > 0 THEN (t.total_transactions / u.tenure_months) * 12 * t.avg_profit_per_transaction
            ELSE 0 -- Avoid division by zero if tenure is 0
        END, 2
    ) AS estimated_clv
FROM user_tenure u
LEFT JOIN transaction_summary t ON u.customer_id = t.owner_id
ORDER BY estimated_clv DESC;

