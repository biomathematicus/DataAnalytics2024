import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from scipy.stats import linregress

class APRateSpreadAnalysis:
    def __init__(self, num_bins=20, x_bounds=[0, 1000]):
        self.num_bins = num_bins
        self.x_bounds = x_bounds

    def load_data(self):
        self.ap_data = pd.read_csv('data/UTSA_AP_BY_SCHOOL.csv')
        self.rate_spread_data = pd.read_csv('data/RATESPREADLEA.csv')
        self.ap_data['LEAID'] = self.ap_data['LEAID'].astype(str).str.lower()
        self.rate_spread_data['leaid'] = self.rate_spread_data['leaid'].astype(str).str.lower()
        self.rate_spread_data.rename(columns={'leaid': 'LEAID', 'avg_rate_spread': 'RateSpread'}, inplace=True)

    def plot_rate_spread_bins(self):
        # Make sure RateSpread is used after renaming
        if 'RateSpread' not in self.rate_spread_data.columns:
            self.rate_spread_data.rename(columns={'avg_rate_spread': 'RateSpread'}, inplace=True)

        # Ensure unique entries for rate spread per LEAID
        self.rate_spread_data = self.rate_spread_data.groupby('LEAID').agg({'RateSpread': 'mean'}).reset_index()
        self.ap_data = self.ap_data.groupby('LEAID').agg({'AP': 'sum'}).reset_index()
        
        # Create bins for rate spread with the right edge included
        self.rate_spread_data['RateSpreadBin'] = pd.cut(self.rate_spread_data['RateSpread'], bins=np.linspace(self.rate_spread_data['RateSpread'].min(), self.rate_spread_data['RateSpread'].max(), self.num_bins + 1), right=True, include_lowest=True)
        
        # Merge datasets on LEAID and sum AP by rate spread bins
        merged_data = pd.merge(self.rate_spread_data, self.ap_data, on='LEAID', how='inner')
        binned_ap_data = merged_data.groupby('RateSpreadBin')['AP'].sum().reset_index()
        
        # Plot the AP distribution across rate spread bins
        plt.figure(figsize=(12, 8))
        plt.bar(binned_ap_data['RateSpreadBin'].astype(str), binned_ap_data['AP'], color='skyblue')
        plt.xticks(rotation=45)
        plt.xlabel('Rate Spread Bins')
        plt.ylabel('Total AP Students')
        plt.title('Total AP Students by Rate Spread Bins')
        plt.grid(True)
        plt.tight_layout()  # Adjust layout to make room for label rotation
        plt.show()

# Use the class
if __name__ == "__main__":
    analysis = APRateSpreadAnalysis()
    analysis.load_data()
    analysis.plot_rate_spread_bins()
