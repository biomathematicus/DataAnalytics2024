#!/bin/bash

# This script downloads ACLF data by iterating through a list of states

# Author: Josiah Sparks
# Date: 29 Aug 2024

OUTPUT_DIR="./Raw Data/ACLF_States"
states=( \
"01_Alabama" \
"02_Alaska" \
"04_Arizona" \
"05_Arkansas" \
"06_California" \
"08_Colorado" \
"09_Connecticut" \
"10_Delaware" \
"11_DistrictofColumbia" \
"12_Florida" \
"13_Georgia" \
"15_Hawaii" \
"16_Idaho" \
"17_Illinois" \
"18_Indiana" \
"19_Iowa" \
"20_Kansas" \
"21_Kentucky" \
"22_Louisiana" \
"23_Maine" \
"24_Maryland" \
"25_Massachusetts" \
"26_Michigan" \
"27_Minnesota" \
"28_Mississippi" \
"29_Missouri" \
"30_Montana" \
"31_Nebraska" \
"32_Nevada" \
"33_NewHampshire" \
"34_NewJersey" \
"35_NewMexico" \
"36_NewYork" \
"37_NorthCarolina" \
"38_NorthDakota" \
"39_Ohio" \
"40_Oklahoma" \
"41_Oregon" \
"42_Pennsylvania" \
"72_PuertoRico" \
"44_RhodeIsland" \
"45_SouthCarolina" \
"46_SouthDakota" \
"47_Tennessee" \
"48_Texas" \
"49_Utah" \
"50_Vermont" \
"51_Virginia" \
"53_Washington" \
"54_WestVirginia" \
"55_Wisconsin" \
"56_Wyoming" \
)
URL_START="https://www2.census.gov/geo/pvs/addcountlisting/2020/"
URL_END="_AddressBlockCountList_062022.txt"

for state in "${states[@]}"; do
  URL="${URL_START}${state}${URL_END}"
  echo "${URL}"
  curl -o "${OUTPUT_DIR}/${state}.csv" $URL
done
