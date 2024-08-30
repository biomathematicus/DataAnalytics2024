import pandas as pd

file_names=[ \
"grf17_lea_tract", \
"grf17_lea_place", \
"grf17_lea_county", \
"grf17_lea_blkgrp" \
]

for file_name in file_names:
  df = pd.read_excel(f'temp/{file_name}.xlsx', engine='openpyxl')
  df.to_csv(f'temp/{file_name}.csv', index=False)