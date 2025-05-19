-- ==========================================
-- Question 3: Flagging inactive accounts
-- Description: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) 
-- Author: Lady Pearl Ampomah Opoku
-- Date: 2025-05-18
-- ==========================================

-- SQL Starts Below

-- CTE to extract the latest transaction date for inflows for each plan
WITH latest_successful_transaction AS (
    SELECT 
        plan_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    WHERE transaction_status IN ('success', 'reward') AND confirmed_amount > 0
    GROUP BY plan_id
)

-- Main querry to identify inactive accounts (savings or investments) with no inflow in the past year
SELECT 
    p.id AS plan_id,
    p.owner_id,
    
    -- Classify plan type as Savings, Investment, or Other based on flags
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    
    -- Use the last successful/reward transaction date if available; otherwise, fall back to plan creation date
    COALESCE(t.last_transaction_date, p.created_on) AS last_transaction_date,
    
    -- Calculate days since last activity
    DATEDIFF(CURDATE(), COALESCE(t.last_transaction_date, p.created_on)) AS inactivity_days
FROM plans_plan p
LEFT JOIN latest_successful_transaction t ON p.id = t.plan_id
WHERE 
    (p.is_regular_savings = 1 OR p.is_a_fund = 1)
    AND p.is_archived = 0 -- Filter plans that have not been archived
    AND p.is_deleted = 0 -- Filter plans that have not been deleted
    AND DATEDIFF(CURDATE(), COALESCE(t.last_transaction_date, p.created_on)) > 365;  -- Filter plans inactive for over a year
