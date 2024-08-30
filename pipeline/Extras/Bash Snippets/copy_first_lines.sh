#!/ban/bash

FILE_NAME="hmda_2017_nationwide_first-lien-owner-occupied-1-4-family-records_labels.csv"
OUTPUT_FILE="first_three_lines.csv"

head -5 ${FILE_NAME} > ${OUTPUT_FILE}
