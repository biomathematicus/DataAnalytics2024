import pandas as pd

file_name='EDGE_GEOCODE_PUBLICSCH_1718'

df = pd.read_excel(f'temp/{file_name}.xlsx', engine='openpyxl')

df.to_csv(f'temp/{file_name}.csv', index=False)