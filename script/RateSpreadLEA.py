import pandas as pd
import matplotlib.pyplot as plt

# Load data from CSV file
file_path = '../data/RATESPREADLEA.csv'
data = pd.read_csv(file_path)

# List of variables to plot
variables = ['apmath', 'advmath', 'apscience', 'apothers', 'algii', 'bio', 'cal', 'chem', 'geo', 'phy']

# Create a plot for each variable
for variable in variables:
    plt.figure(figsize=(10, 6))
    plt.errorbar(data[variable], data['avg_rate_spread'], yerr=data['StandardDeviation'], fmt='o', ecolor='red', capsize=5)
    plt.xlabel(variable.capitalize())
    plt.ylabel('Average Rate Spread')
    plt.title(f'{variable.capitalize()} vs. Rate Spread')
    plt.grid(True)
    plt.show()
