-- Step 1: Create a CTE to count the number of transactions per customer per month
WITH mnthly_txn AS (
    SELECT
        s.owner_id,  -- ID of the customer who owns the transaction
        DATE_FORMAT(s.transaction_date, '%Y-%m-01') AS month,  -- Normalize transaction date to the first day of the month
        COUNT(*) AS transaction_count  -- Count of transactions in that month
    FROM
        savings_savingsaccount s
    GROUP BY
        s.owner_id, DATE_FORMAT(s.transaction_date, '%Y-%m-01')  -- Group by customer and month
),

-- Step 2: Calculate each customer's average number of transactions per month
cust_avg AS (
    SELECT
        owner_id,  -- Customer ID
        AVG(transaction_count) AS avg_transactions_per_month  -- Average monthly transaction count
    FROM
        mnthly_txn
    GROUP BY
        owner_id  -- Group by customer
)

-- Step 3: Categorize customers by their transaction frequency and summarize the groups
SELECT
    -- Define frequency category based on average transactions per month
    CASE
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month >= 3 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,

    COUNT(*) AS customer_count,  -- Number of customers in each frequency category

    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month  -- Average transaction frequency within each category

FROM
    cust_avg

GROUP BY
    frequency_category  -- Group results by the assigned frequency category

-- Order the categories logically from high to low
