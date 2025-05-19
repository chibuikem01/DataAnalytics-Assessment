-- Create a Common Table Expression (CTE) to get the most recent transaction date for each customer
WITH Current_txns AS (
    SELECT
        owner_id,
        DATE(MAX(transaction_date)) AS last_transaction_date  -- Get the latest transaction date, only the date part
    FROM
        savings_savingsaccount
    GROUP BY
        owner_id  -- Group by user to aggregate their latest transaction
)

-- Use the CTE to find inactive savings or investment plans
SELECT
    p.id AS plan_id,  -- Unique ID of the plan
    p.owner_id,  -- ID of the customer who owns the plan

    -- Categorize the plan type based on its flags
    CASE
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,

    lt.last_transaction_date,  -- The most recent transaction date for the customer
    DATEDIFF(CURRENT_DATE(), lt.last_transaction_date) AS inactivity_days  -- Number of days since last transaction

FROM
    plans_plan p
JOIN
    Current_txns lt ON p.owner_id = lt.owner_id  -- Join plans with latest transaction data

WHERE
    lt.last_transaction_date < DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY)  -- Only include users with no transactions in the last 365 days
    AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)  -- Filter for only savings or investment plans

ORDER BY
    inactivity_days DESC;  -- Rank by longest inactivity
