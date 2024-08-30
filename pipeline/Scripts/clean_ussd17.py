import pandas as pd

# Read the Excel file
df = pd.read_excel('temp/ussd17.xls', engine='xlrd', header=2)

df.columns = ["state", "state_FIPS","DistrictID", "NameSchoolDistrict","TotalPopulation", "Population5_17","Population5_17InPoverty"]

df.to_csv('temp/ussd17.csv', index=False)