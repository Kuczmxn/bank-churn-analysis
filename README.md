# Bank Customer Churn & Retention Analysis

## 1. Business Objective
Customer attrition directly impacts retail banking profitability and deposit stability. The goal of this project is to identify the key demographic and behavioral drivers behind customer churn, quantify the total capital lost, and segment high-risk customer groups.

Instead of building a black-box machine learning model, this project focuses on **end-to-end Business Intelligence and descriptive analytics**—translating raw customer records into actionable retention strategies for marketing and customer success teams.

---

## 2. Tech Stack & Repository Structure
* **Python (Pandas):** Exploratory data quality checks, data cleaning, and business feature engineering.
* **SQL (SQLite):** Relational database setup and analytical querying (aggregations, conditional logic, CTEs, and window functions).
* **Power BI:** Interactive executive dashboard for self-service filtering and KPI monitoring.

---

## 3. Data Preparation & Feature Engineering (Python)
Before running any aggregations, `processing_data.py` enforces data integrity and creates business-ready segments:
1. **Data Quality Validation:** Verified dataset dimensions (10,000 rows), checked for missing values and duplicate `customer_id` records, and enforced binary target validation (`assert` on `churn` values `{0, 1}`).
2. **Dimensionality Reduction:** Dropped non-predictive identifier columns (`customer_id`).
3. **Age Bracketing (`pd.cut`):** Grouped continuous age values into left-closed business cohorts (`18-29`, `30-39`, `40-49`, `50-59`, `60+`).
4. **Balance Segmentation (`pd.qcut`):** Separated zero-balance accounts (`No balance`) from active depositors, splitting non-zero balances into three equal-sized quantiles (`Low`, `Medium`, `High`) to avoid arbitrary threshold bias.

---

## 4. Key Analytical Findings (SQL & KPIs)
Using `analysis.sql`, seven business questions were evaluated against the `customers` table:

* **Overall Churn & Capital Impact:** Out of **10,000** customers, **2,037** churned, resulting in an overall churn rate of **20.37%** and **$185.59M** in lost account balances.
* **Age Vulnerability:** Customers aged **[wpisz grupę z najwyższym % z SQL, np. 50-59]** exhibit the highest churn rate at **[wpisz %]** (compared to **[wpisz %]** in the `18-29` cohort).
* **Engagement Effect:** Inactive members churn at a rate of **[wpisz %]**, which is nearly **[wpisz mnożnik, np. 2x]** higher than active members (**[wpisz %]**).
* **Account Balance Segments:** Customers holding balances in the **[wpisz segment z SQL, np. Medium / High]** tier show a higher propensity to leave (**[wpisz %]**) than zero-balance accounts (**[wpisz %]**), indicating high-value deposit flight.
* **Regional Benchmarks (CTE & Window Functions):** Using a Common Table Expression (`WITH`) and `RANK() OVER()`, **[wpisz kraj, np. Germany]** ranked #1 in attrition, exceeding the bank-wide average churn rate by **[wpisz różnicę z kolumny difference_vs_average] percentage points**.

---

## 5. Interactive Dashboard (Power BI)
The Power BI report connects directly to `cleaned_bank_churn.csv` and provides dynamic filtering across **Country**, **Gender**, and **Active Member** status.

---

## 6. Actionable Business Recommendations
1. **Target High-Balance Inactive Customers:** Launch automated re-engagement campaigns (e.g., personalized relationship manager outreach or preferential term-deposit rates) for inactive clients in the `Medium` and `High` balance segments before they close their accounts.
2. **Age-Specific Retention Offers:** Design tailored financial products (such as retirement/wealth preservation packages) aimed specifically at the **40–59** demographic, where attrition volume and rate peak.
3. **Regional Audit:** Investigate product-market fit and competitor pricing in the highest-churn country identified in the SQL benchmark query.
