Customer Insights SQL Scripts

This repository provides a collection of SQL queries designed to extract meaningful insights from customer savings and investment activity. These scripts help identify high-value customers, detect inactivity, track participation across products, 
and segment users by transaction frequency.

Overview of Scripts

1. **Customer Lifetime Value (CLV) Estimation**
Estimates each customer’s potential lifetime value based on:

- Tenure (months since account creation)
- Total number and value of confirmed savings transactions
- A computed CLV score using average transaction value and monthly frequency

 **Use Case**: Prioritize high-value customers for loyalty or upsell campaigns.


2. **Inactive Plans Detection**
Identifies savings and investment plans with **no activity in the past 12 months** by:

- Extracting the last transaction date per customer
- Filtering for plans with over 365 days of inactivity

**Use Case**: Flag dormant accounts for reactivation or closure workflows.


3. **Savings & Investment Participation**
Finds customers who:

- Have made deposits into savings accounts
- Also have at least one investment plan

Outputs total number of accounts and total deposits (in Naira) per user.

**Use Case**: Profile users who are financially engaged across multiple product lines.


4. **Transaction Frequency Segmentation**
Segments customers based on their **monthly savings transaction activity**:

- High Frequency: = 10/month
- Medium Frequency: 3–9/month
- Low Frequency: < 3/month

Also returns average frequency per group and number of users.

 **Use Case**: Target communications and incentives based on user activity levels.


 Data Assumptions

- Monetary values are stored in **kobo** and converted to **Naira** using `/ 100.0`.
- Table names used:
  users_customuser`
  savings_savingsaccount`
  plans_plan`
- Dates are handled using standard MySQL date functions.

- SQL (MySQL syntax)
- Suitable for use in BI tools or ETL pipelines




