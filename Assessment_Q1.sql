-- ==========================================
-- Question 1: Identify high-Value Customers with Savings and Investment Plans
-- Description: Identify users with at least one funded savings plan AND one funded investment plan
-- Sorted by total deposits
-- Author: Lady Pearl Ampomah Opoku
-- Date: 2025-05-18
-- ==========================================

-- SQL Starts Below

-- CTE: Get funded savings plans
WITH savings_plans AS (
    SELECT 
        s.owner_id,
        COUNT(DISTINCT s.plan_id) AS savings_count,
        SUM(s.amount) AS savings_total
    FROM savings_savingsaccount s
    JOIN plans_plan p ON s.plan_id = p.id
    WHERE p.is_regular_savings = 1
      AND s.confirmed_amount > 0
    GROUP BY s.owner_id
),

-- CTE: Get funded investment plans
investment_plans AS (
    SELECT 
        s.owner_id,
        COUNT(DISTINCT s.plan_id) AS investment_count,
        SUM(s.amount) AS investment_total
    FROM savings_savingsaccount s
    JOIN plans_plan p ON s.plan_id = p.id
    WHERE p.is_a_fund = 1
      AND s.confirmed_amount > 0
    GROUP BY s.owner_id
)

-- Combine both and filter for users with at least one funded plan type
SELECT 
    uc.id AS owner_id,
    CONCAT(uc.first_name, ' ', uc.last_name) AS name,
    sp.savings_count,
    ip.investment_count,
    ROUND(COALESCE(sp.savings_total, 0) + COALESCE(ip.investment_total, 0), 2) AS total_deposits -- Calculate total confirmed deposits per user (inflows)
FROM users_customuser uc
JOIN savings_plans sp ON uc.id = sp.owner_id
JOIN investment_plans ip ON uc.id = ip.owner_id
ORDER BY total_deposits DESC;
