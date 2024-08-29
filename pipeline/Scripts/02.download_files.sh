#!/ban/bash

# This script downloads necessary data from online sources

# Author: Josiah Sparks
# Date: 29 Aug 2024

RAW_DIR="./Raw Data"
CRDC_1718_URL="https://civilrightsdata.ed.gov/assets/ocr/docs/2017-18-crdc-data.zip"
SAIPE_URL="https://www2.census.gov/programs-surveys/saipe/datasets/2017/2017-school-districts/ussd17.xls"
HMDA_GEO_URL="https://nces.ed.gov/programs/edge/data/EDGE_GEOCODE_PUBLICSCH_1718.zip"
HMDA_URL="https://files.consumerfinance.gov/hmda-historic-loan-data/hmda_2017_nationwide_first-lien-owner-occupied-1-4-family-records_labels.zip"
SDGR_URL="https://nces.ed.gov/programs/edge/data/GRF17.zip"

curl -o "$RAW_DIR/2017-18-crdc-data.zip" "$CRDC_1718_URL"

curl -o "$RAW_DIR/ussd17.xls" "$SAIPE_URL"

curl -o "$RAW_DIR/EDGE_GEOCODE_PUBLICSCH_1718.zip" "$HMDA_GEO_URL"

curl -o "$RAW_DIR/HMDA2017.zip" "$HMDA_URL"

curl -o "$RAW_DIR/GRF17.zip" "$SDGR_URL"




