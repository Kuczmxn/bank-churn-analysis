import pandas as pd

# 1. Reading CSV file
data = pd.read_csv('raw_data/Bank Customer Churn Prediction.csv')

# 2. Data quality checks
print("Shape (rows, columns):", data.shape)
print(data.info())

# Missing values
print("Missing values per column:")
print(data.isna().sum())

# Duplicates
print("Duplicated rows:", data.duplicated().sum())
print("Duplicated customer_id:", data['customer_id'].duplicated().sum())

# Basic statistics - look for strange values (e.g. negative balance, age out of range)
print(data.describe())

# Categorical columns - look for typos or unexpected categories
print(data['country'].value_counts())
print(data['gender'].value_counts())

# Target column should contain only 0 and 1
print(data['churn'].value_counts())
assert set(data['churn'].unique()) <= {0, 1}

# 3. Data cleaning
# customer_id is only an identifier, it is not useful for analysis
columns_to_drop = ['customer_id']
data = data.drop(columns=columns_to_drop)

# 4. Feature engineering
# 4a. Age groups
age_bins = [18, 30, 40, 50, 60, 100]
age_labels = ['18-29', '30-39', '40-49', '50-59', '60+']

# right=False means that the interval is closed on the left and open on the right,
# so 30 will be included in the second bin (30-39), not in the first one (18-29)
data['age_group'] = pd.cut(data['age'], bins=age_bins, labels=age_labels, right=False)

# Checking if every customer got an age group
print("Customers without age group:", data['age_group'].isna().sum())

# 4b. Balance segments
# Customers with zero balance are a separate group,
# the rest is split into 3 equal-sized groups (Low / Medium / High)
data['balance_segment'] = 'No balance'
has_balance = data['balance'] > 0
data.loc[has_balance, 'balance_segment'] = pd.qcut(
    data.loc[has_balance, 'balance'], q=3, labels=['Low', 'Medium', 'High']
).astype(str)

# Checking the balance range of each segment
print(data.groupby('balance_segment')['balance'].agg(['min', 'max', 'count']))

# Checking structure of the data after feature engineering
print(data.head())

# 5. Export the cleaned and processed data to a new CSV file
data.to_csv('cleaned_bank_churn.csv', index=False)
print("Data cleaning and processing completed.")