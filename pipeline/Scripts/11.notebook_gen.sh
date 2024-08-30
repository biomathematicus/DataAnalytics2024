#!/ban/bash

# This script generates a Jupyter notebook. 

# Author: Josiah Sparks
# Date: 29 Aug 2024

CONTAINER_NAME="python-runner"
INPUT_DIR="./Scripts/Notebooks"
OUTPUT_DIR="./Jupyter Output"
SCRIPT_NAME="make_notebook.py"

for notebook in "$INPUT_DIR"/*.ipynb; do
  notebook_name=$(basename "$notebook")
  sanitized_name=$(echo "$notebook_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

  docker cp "${notebook}" "$CONTAINER_NAME:/app/temp/$sanitized_name"

  exec_cmd="jupyter nbconvert --to html --execute /app/temp/${sanitized_name}"
  winpty docker exec "$CONTAINER_NAME" bash -c "${exec_cmd}"

  docker cp "$CONTAINER_NAME:/app/temp/${sanitized_name%.ipynb}.html" "$(pwd)/$OUTPUT_DIR"
done

