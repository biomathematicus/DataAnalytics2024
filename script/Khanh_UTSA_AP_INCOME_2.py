import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm, skew, kurtosis

class APDataAnalysis:
    def __init__(self, file_path_ratespread, file_path_utsa_ap):
        self.data_ratespread = pd.read_csv(file_path_ratespread)
        self.data_utsa_ap = pd.read_csv(file_path_utsa_ap)
        self.merged_data = None
        self.normalize_subjects()

    def normalize_subjects(self):
        # Merge datasets on 'leaid'
        self.merged_data = pd.merge(self.data_ratespread, self.data_utsa_ap, left_on='leaid', right_on='LEAID')
        # Normalization of AP subjects
        self.merged_data['apmath_norm'] = self.merged_data['apmath'] / self.merged_data['TOTAL']
        # Filter out loan amounts greater than 300k
        self.merged_data = self.merged_data[self.merged_data['applicant_income_000s'] <= 120]

    def plot_data(self):
        subject = 'apmath_norm'
        data = self.merged_data[subject].dropna()  # Remove NaN values for fitting
        # Fit a Gaussian distribution
        mu, std = norm.fit(data)
        skewness = skew(data)
        kurtosis_val = kurtosis(data)

        # Plotting
        fig, ax = plt.subplots(figsize=(10, 6))
        # Scatter plot
        ax.scatter(self.merged_data['applicant_income_000s'], self.merged_data[subject], alpha=0.5, label='Data')
        
        # Gaussian fit line
        x = np.linspace(min(data), max(data), 100)
        y = norm.pdf(x, mu, std)
        
        # Scale y to the y-axis range of the scatter plot
        y = (y - y.min()) / (y.max() - y.min()) * (max(data) - min(data)) + min(data)
        ax.plot(np.linspace(min(self.merged_data['applicant_income_000s']), max(self.merged_data['applicant_income_000s']), 100), y, 'k', linewidth=2, label='Fit')
        
        title = f'AP Math Normalized - Mean: {mu:.2f}, Std Dev: {std:.2f}, Skewness: {skewness:.2f}, Kurtosis: {kurtosis_val:.2f}'
        
        # Area calculations
        area_left = norm.cdf(mu, mu, std)  # Area under the curve to the left of the mean
        area_right = 1 - area_left  # Area under the curve to the right of the mean
        area_ratio = area_right / area_left
        title += f', Area Ratio (R/L): {area_ratio:.2f}'
        
        ax.set_title(title)
        ax.set_xlabel('Income (000s)')
        ax.set_ylabel('Normalized AP Math')
        ax.legend()
        plt.show()

# Instantiate and use the class with the uploaded files
file_path_ratespread = 'data/RATESPREADLEA.csv'
file_path_utsa_ap = 'data/UTSA_AP_BY_SCHOOL.csv'
ap_data_analysis = APDataAnalysis(file_path_ratespread, file_path_utsa_ap)
ap_data_analysis.plot_data()
