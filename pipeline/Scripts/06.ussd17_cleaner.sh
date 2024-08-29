#!/ban/bash

# This script copies ussd17.xls into the Python container, executes Python to convert it to CSV, and retrieves the CSV to place it in the Data folder locally. 

# Author: Josiah Sparks
# Date: 29 Aug 2024

CONTAINER_NAME="python-runner"

docker cp \
Scripts/clean_ussd17.py \
"$CONTAINER_NAME:/app/temp/clean_ussd17.py"

docker cp \
Data/ussd17.xls \
"$CONTAINER_NAME:/app/temp/ussd17.xls"

docker exec $CONTAINER_NAME python temp/clean_ussd17.py

docker cp \
"$CONTAINER_NAME:app/temp/ussd17.csv" \
./Data
