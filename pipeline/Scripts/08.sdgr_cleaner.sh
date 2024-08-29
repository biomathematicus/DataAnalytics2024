#!/ban/bash

# This script converts multiple .xlsx files to CSV. 

# Author: Josiah Sparks
# Date: 29 Aug 2024

CONTAINER_NAME="python-runner"
file_names=( \
"grf17_lea_tract" \
"grf17_lea_place" \
"grf17_lea_county" \
"grf17_lea_blkgrp" \
)
PY_SCRIPT="clean_sdgr.py"

docker cp \
"Scripts/${PY_SCRIPT}" \
"$CONTAINER_NAME:/app/temp/${PY_SCRIPT}"

for file_name in "${file_names[@]}"; do
  docker cp \
  Data/SDGR/GRF17/${file_name}.xlsx \
  "$CONTAINER_NAME:/app/temp/${file_name}.xlsx"
done

docker exec $CONTAINER_NAME python temp/"${PY_SCRIPT}"

for file_name in "${file_names[@]}"; do
  docker cp \
  "$CONTAINER_NAME:app/temp/${file_name}.csv" \
  ./Data
done


