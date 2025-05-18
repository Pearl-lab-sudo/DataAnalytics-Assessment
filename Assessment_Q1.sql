-- ==========================================
-- Question 1: [Identifying high-value cross-sell customers]
-- Description: [Identify customers who have both a savings and an investment plan]
-- Author: Lady Pearl Ampomah Opoku
-- Date: 2025-05-18
-- ==========================================

-- SQL Starts Below

-- CTE to count the number of regular savings plans per user
WITH savings AS (
    SELECT owner_id, COUNT(*) AS savings_count
    FROM plans_plan
    WHERE is_regular_savings = 1
    GROUP BY owner_id
),

-- CTE to count the number of investment plans per user
investments AS (
    SELECT owner_id, COUNT(*) AS investment_count
    FROM plans_plan
    WHERE is_a_fund = 1
    GROUP BY owner_id
),

-- CTE to calculate total confirmed deposits per user (inflows)
deposits AS (
    SELECT owner_id, SUM(confirmed_amount) AS total_deposits
    FROM savings_savingsaccount
    GROUP BY owner_id
)

-- Final query to combine user info with savings, investment, and deposit stats
SELECT 
    uc.id AS owner_id,
    CONCAT(uc.first_name, ' ', uc.last_name) AS name,
    s.savings_count,
    i.investment_count,
    ROUND(COALESCE(d.total_deposits, 0) / 100, 2) AS total_deposits -- Normalize deposit value & handle NULLs --
FROM users_customuser uc
JOIN savings s ON uc.id = s.owner_id
JOIN investments i ON uc.id = i.owner_id
LEFT JOIN deposits d ON uc.id = d.owner_id
ORDER BY total_deposits DESC;
