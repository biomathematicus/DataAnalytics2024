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
        ap_subjects = ['apmath', 'advmath', 'apscience', 'apothers', 'algii', 'bio', 'cal', 'chem', 'geo', 'phy']
        for subject in ap_subjects:
            self.merged_data[subject + '_norm'] = self.merged_data[subject] / self.merged_data['TOTAL']

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
        ax.scatter(self.merged_data['loan_amount_000s'], self.merged_data[subject], alpha=0.5, label='Data')
        # Fit line
        xmin, xmax = ax.get_xlim()
        x = np.linspace(xmin, xmax, 100)
        p = norm.pdf(x, mu, std)
        ax.plot(x, p * std + min(self.merged_data[subject]), 'k', linewidth=2, label='Fit')
        title = f'AP Math Normalized - Mean: {mu:.2f}, Std Dev: {std:.2f}, Skewness: {skewness:.2f}, Kurtosis: {kurtosis_val:.2f}'
        
        # Area calculations
        area_left = norm.cdf(mu, mu, std)  # Area under the curve to the left of the mean
        area_right = 1 - area_left  # Area under the curve to the right of the mean
        area_ratio = area_right / area_left
        title += f', Area Ratio (R/L): {area_ratio:.2f}'
        
        ax.set_title(title)
        ax.set_xlabel('Loan Amount (000s)')
        ax.set_ylabel('Normalized AP Math')
        ax.legend()
        plt.show()

# Instantiate and use the class
file_path_ratespread = 'data/RATESPREADLEA.csv'
file_path_utsa_ap = 'data/UTSA_AP_BY_SCHOOL.csv'
ap_data_analysis = APDataAnalysis(file_path_ratespread, file_path_utsa_ap)
ap_data_analysis.plot_data()
