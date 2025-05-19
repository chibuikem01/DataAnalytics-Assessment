-- Create a Common Table Expression (CTE) to calculate basic customer stats
WITH cust_status AS (
    SELECT
        u.id AS customer_id,  -- Unique customer ID
        CONCAT(u.first_name, ' ', u.last_name) AS name,  -- Full name of the customer
        TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) AS tenure_months,  -- Number of months since the customer joined
        COUNT(s.id) AS total_transactions,  -- Total number of transactions made by the customer
        SUM(s.confirmed_amount / 100.0) AS total_transaction_value  -- Total value of all confirmed transactions, converted from cents to dollars
    FROM
        users_customuser u
    LEFT JOIN
        savings_savingsaccount s ON u.id = s.owner_id  -- Join savings accounts to users
    GROUP BY
        u.id, u.first_name, u.last_name, u.date_joined  -- Group by customer to aggregate transactions
)

-- Use the CTE to calculate estimated Customer Lifetime Value (CLV)
SELECT
    customer_id,
    name,
    tenure_months,
    total_transactions,
    
    -- Estimated CLV calculation:
    -- (transactions per month) * 12 months * (average transaction value scaled by 0.001)
    ROUND(
        (total_transactions / NULLIF(tenure_months, 0)) * 12 *
        (0.001 * COALESCE(total_transaction_value, 0) / NULLIF(total_transactions, 0)),
        2  -- Round to 2 decimal places
    ) AS estimated_clv

FROM
    cust_status
WHERE
    tenure_months > 0  -- Only include customers with a tenure greater than zero
ORDER BY
    estimated_clv DESC;  -- Rank customers from highest to lowest estimated CLV
