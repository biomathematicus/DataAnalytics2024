import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from scipy.stats import linregress

# Define the x-axis bounds
x_bounds = [0, 1000]

# Load the datasets
ap_data = pd.read_csv('../data/UTSA_AP_BY_SCHOOL.csv')
rate_spread_data = pd.read_csv('../data/RATESPREADLEA.csv')

# Ensure LEAID columns are strings and lower case for consistent merging
ap_data['LEAID'] = ap_data['LEAID'].astype(str).str.lower()
rate_spread_data['leaid'] = rate_spread_data['leaid'].astype(str).str.lower()
rate_spread_data.rename(columns={'leaid': 'LEAID'}, inplace=True)

# Sum the AP credits by school district (LEAID) and apply x-axis bounds
ap_summary = ap_data.groupby('LEAID')['AP'].sum().reset_index()
ap_summary = ap_summary[(ap_summary['AP'] >= x_bounds[0]) & (ap_summary['AP'] <= x_bounds[1])]

# Merge the datasets on LEAID
merged_data = pd.merge(ap_summary, rate_spread_data, on='LEAID', how='inner')

# Perform linear regression
regression_results = linregress(merged_data['AP'], merged_data['avg_rate_spread'])

# Unpack regression results
slope = regression_results.slope
intercept = regression_results.intercept
r_value = regression_results.rvalue
r_squared = r_value**2

# Create regression line for plotting
regression_line = slope * merged_data['AP'] + intercept

# Update plot with regression information and x_bounds
plt.figure(figsize=(10, 6))
plt.errorbar(merged_data['AP'], merged_data['avg_rate_spread'], yerr=merged_data['standarddeviation'], fmt='o', ecolor='red', capsize=5)
plt.plot(merged_data['AP'], regression_line, color='blue', label=f'Linear fit: y = {slope:.2f}x + {intercept:.2f}\n$R^2 = {r_squared:.4f}$')
plt.xlabel('Total AP per School District')
plt.ylabel('Average Rate Spread')
plt.title('AP Scores vs. Mortgage Rate Spread by School District')
plt.xlim(x_bounds)
plt.legend()
plt.grid(True)
plt.show()

# Output regression parameters and R^2
print(f"Linear Regression Equation: y = {slope:.2f}x + {intercept:.2f}")
print(f"Slope: {slope:.2f}")
print(f"Intercept: {intercept:.2f}")
print(f"R-squared: {r_squared:.4f}")
