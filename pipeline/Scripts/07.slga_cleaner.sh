#!/ban/bash

# This script copies the SLGA data into the Python container to extract a CSV version of the original .xlsx file.

# Author: Josiah Sparks
# Date: 29 Aug 2024

CONTAINER_NAME="python-runner"
FILE_NAME=EDGE_GEOCODE_PUBLICSCH_1718

docker cp \
Scripts/clean_slga.py \
"$CONTAINER_NAME:/app/temp/clean_slga.py"

docker cp \
Data/HMDA_GEO/${FILE_NAME}/${FILE_NAME}.xlsx \
"$CONTAINER_NAME:/app/temp/${FILE_NAME}.xlsx"

docker exec $CONTAINER_NAME python temp/clean_slga.py

docker cp \
"$CONTAINER_NAME:app/temp/${FILE_NAME}.csv" \
./Data
