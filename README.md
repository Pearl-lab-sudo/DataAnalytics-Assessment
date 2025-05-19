# 📊 Cowrywise SQL Technical Assessment

## Overview

This repository contains my SQL solutions for the Cowrywise Data Analyst Technical Assessment. The queries were written to solve business problems related to customer behavior, account activity, and revenue estimation using transactional data.

Each file corresponds to one assessment question, formatted and documented to ensure readability and clarity.

---

## 📁 Contents

This repository includes queries and analyses based on four core tables:

- `users_customuser`: Contains customer profile data.
- `plans_plan`: Holds information about different financial plans (savings and investment).
- `savings_savingsaccount`: Records detailed transaction-level data.
- `withdrawals_withdrawal`: Captures withdrawal records.

---

## 📁 Repository Structure
DataAnalytics-Assessment/

│

├── Assessment_Q1.sql # High-Value Customers with Multiple Products

├── Assessment_Q2.sql # Transaction Frequency Analysis

├── Assessment_Q3.sql # Account Inactivity Alert

├── Assessment_Q4.sql # Customer Lifetime Value (CLV) Estimation

└── README.md # Explanation of solutions and challenges

---

## ✅ Solutions

### Q1: High-Value Customers with Multiple Products

**Objective**  
Identify customers with at least one funded savings plan *and* one funded investment plan. Sort them by total confirmed deposits.

**Tables Used**  
- `users_customuser`  
- `savings_savingsaccount`  
- `plans_plan`

**Approach**  
- Created CTEs to identify users with funded savings and funded investment plans (based on `confirmed_amount > 0` and plan type flags).
- Joined both CTEs on `owner_id` to find users with both product types.
- Calculated number of funded plans and total deposits.
- Joined with `users_customuser` for user info and sorted by total deposits.

**SQL Concepts**  
`CTE`, `JOIN`, `GROUP BY`, `WHERE`, `CASE`, Aggregation

---

### Q2: Transaction Frequency Analysis

**Objective**  
Calculate the average number of transactions per user per month and categorize users into frequency groups:

- High Frequency: ≥ 10/month  
- Medium Frequency: 3–9/month  
- Low Frequency: ≤ 2/month

**Tables Used**  
- `users_customuser`  
- `savings_savingsaccount`

**Approach**  
- Filtered for successful transactions.
- Counted monthly transactions per user.
- Calculated average transactions/month.
- Used `CASE` to assign frequency categories.
- Aggregated the result by frequency group.

**SQL Concepts**  
Date functions, `CTE`, `GROUP BY`, `CASE`, `AVG`

---

### Q3: Account Inactivity Alert

**Objective**  
Find all active savings or investment plans with no inflow transactions in the last 365 days.

**Tables Used**  
- `savings_savingsaccount`  
- `plans_plan`

**Approach**  
- Used a CTE to get the last inflow date per plan (transaction type: `success` or `reward`).
- Joined with `plans_plan` to include metadata and filter active plans.
- Used `COALESCE` to substitute missing dates with plan creation date.
- Calculated days since last activity using `DATEDIFF`.
- Filtered plans with inactivity > 365 days.

**SQL Concepts**  
`LEFT JOIN`, `COALESCE`, `DATEDIFF`, Filtering, `WHERE`

---

### Q4: Customer Lifetime Value (CLV) Estimation

**Objective**  
Estimate CLV using:
CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction

**Tables Used**  
- `savings_savingsaccount`  
- `users_customuser`

**Assumption**  
Profit per transaction is 0.1% of confirmed deposit.

**Approach**  
- Counted number of inflow transactions and calculated total confirmed deposits.
- Estimated average profit per transaction.
- Computed tenure in months using the difference between `date_joined` and current date.
- Applied CLV formula while handling 0-month tenure with `CASE` logic.

**SQL Concepts**  
Mathematical expressions, `DATEDIFF`, `COALESCE`, `JOIN`, `CASE`

---

## 📊 Results and Insights

- **High-Value Customers**: Identified customers engaged in both savings and investments with large deposits.
- **Frequency Segments**: Grouped users into High, Medium, and Low transaction frequency segments.
- **Inactive Plans**: Flagged active but dormant plans for re-engagement campaigns.
- **CLV Ranking**: Estimated each customer’s potential value to inform retention and prioritization strategies.

---

## 🛠 Tools Used

- **SQL (MySQL)** – Core tool used for querying and analysis

---

## 🚀 Recommendations

- Target high- and medium-frequency users for loyalty programs or retention strategies.
- Reach out to users with dormant accounts using targeted nudges.
- Leverage CLV to focus marketing efforts on top-tier customers.
- Continue monitoring transaction patterns to refine segmentation thresholds over time.

---

## 👩‍💻 Author

**Lady Pearl Ampomah Opoku**  
Data Analyst | Passionate about turning data into actionable insights  

---

Thank you for reviewing this project!
