# Select the states you want to include in the supplementary material
state_string = [
    'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC', 'FL',
    'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME',
    'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH',
    'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'PR',
    'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV',
    'WI', 'WY'
]

state_full_names = {
    'AL': 'Alabama', 'AK': 'Alaska', 'AZ': 'Arizona', 'AR': 'Arkansas', 'CA': 'California', 
    'CO': 'Colorado', 'CT': 'Connecticut', 'DE': 'Delaware', 'DC': 'District of Columbia', 
    'FL': 'Florida', 'GA': 'Georgia', 'HI': 'Hawaii', 'ID': 'Idaho', 'IL': 'Illinois', 
    'IN': 'Indiana', 'IA': 'Iowa', 'KS': 'Kansas', 'KY': 'Kentucky', 'LA': 'Louisiana', 
    'ME': 'Maine', 'MD': 'Maryland', 'MA': 'Massachusetts', 'MI': 'Michigan', 
    'MN': 'Minnesota', 'MS': 'Mississippi', 'MO': 'Missouri', 'MT': 'Montana', 
    'NE': 'Nebraska', 'NV': 'Nevada', 'NH': 'New Hampshire', 'NJ': 'New Jersey', 
    'NM': 'New Mexico', 'NY': 'New York', 'NC': 'North Carolina', 'ND': 'North Dakota', 
    'OH': 'Ohio', 'OK': 'Oklahoma', 'OR': 'Oregon', 'PA': 'Pennsylvania', 
    'PR': 'Puerto Rico', 'RI': 'Rhode Island', 'SC': 'South Carolina', 'SD': 'South Dakota', 
    'TN': 'Tennessee', 'TX': 'Texas', 'UT': 'Utah', 'VT': 'Vermont', 'VA': 'Virginia', 
    'WA': 'Washington', 'WV': 'West Virginia', 'WI': 'Wisconsin', 'WY': 'Wyoming'
}


latex_content = r"""
\documentclass[12pt]{article}
\usepackage{graphicx}
\usepackage[margin=1in]{geometry}

\begin{document}
\title{Supplementary Material}
\section{Appendix}

"""

filenames = ["../Figures/Histograms/Poverty_vs_Alg2_" + state + ".png" for state in state_string]
latex_content += r"\subsection{Poverty Histograms}" + "\n"
latex_content += r"short description of general process to find the proportions etc. etc." + "\n"
for state, filename in zip(state_string, filenames):
    latex_content += r"\newpage" + "\n"
    latex_content += r"\begin{figure}[h!]" + "\n"
    latex_content += r"\centering" + "\n"
    latex_content += r"\includegraphics[width=\textwidth]{" + filename + "}" + "\n"
    latex_content += r"\caption{" + state_full_names[state] + " graphic output}" + "\n"
    latex_content += r"\end{figure}" + "\n\n"


filenames = ["../Figures/Income_StateMaps/IncomeMap_" + state + ".png" for state in state_string]
latex_content += r"\subsection{Income Family per State County Subdivision}" + "\n"
latex_content += r"short description of general process to find the proportions etc. etc." + "\n"
for state, filename in zip(state_string, filenames):
    latex_content += r"\newpage" + "\n"
    latex_content += r"\begin{figure}[h!]" + "\n"
    latex_content += r"\centering" + "\n"
    latex_content += r"\includegraphics[width=\textwidth]{" + filename + "}" + "\n"
    latex_content += r"\caption{" + state_full_names[state] + " graphic output}" + "\n"
    latex_content += r"\end{figure}" + "\n\n"

filenames = ["../Figures/Loan_StateMaps/LoanMap_" + state + ".png" for state in state_string]
latex_content += r"\subsection{Loan per State County Subdivision}" + "\n"
latex_content += r"short description of general process to find the proportions etc. etc." + "\n"
for state, filename in zip(state_string, filenames):
    latex_content += r"\newpage" + "\n"
    latex_content += r"\begin{figure}[h!]" + "\n"
    latex_content += r"\centering" + "\n"
    latex_content += r"\includegraphics[width=\textwidth]{" + filename + "}" + "\n"
    latex_content += r"\caption{" + state_full_names[state] + " graphic output}" + "\n"
    latex_content += r"\end{figure}" + "\n\n"

# Close the document
latex_content += r"\end{document}"

# Write to a .tex file
with open("../SupplementaryMaterial/SupplementaryMaterialSource.tex", "w") as file:
    file.write(latex_content)