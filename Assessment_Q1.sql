-- Retrieve users who have both savings and investment accounts with deposits
SELECT
    u.id AS owner_id,  -- Unique ID of the user
    CONCAT(u.first_name, ' ', u.last_name) AS name,  -- Full name of the user

    -- Count of distinct savings accounts with deposits (confirmed_amount > 0)
    COUNT(DISTINCT CASE WHEN s.id IS NOT NULL THEN s.id END) AS savings_count,

    -- Count of distinct investment plans (where is_a_fund = 1)
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,

    -- Sum of confirmed savings deposits, converted from kobo to Naira
    SUM(s.confirmed_amount / 100.0) AS total_deposits

FROM
    users_customuser u

-- Join to savings accounts only if the confirmed_amount is greater than 0
LEFT JOIN
    savings_savingsaccount s ON u.id = s.owner_id AND s.confirmed_amount > 0

-- Join to investment plans (where is_a_fund = 1)
LEFT JOIN
    plans_plan p ON u.id = p.owner_id AND p.is_a_fund = 1

GROUP BY
    u.id, u.first_name, u.last_name  -- Group by user to aggregate their account details

HAVING
    -- Ensure the user has at least one savings account with a deposit
    COUNT(DISTINCT CASE WHEN s.id IS NOT NULL THEN s.id END) > 0
    -- Ensure the user has at least one investment plan
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) > 0

ORDER BY
    total_deposits DESC;  -- Rank users by total deposit amount in descending order
