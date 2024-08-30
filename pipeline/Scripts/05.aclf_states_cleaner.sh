#!/ban/bash

# In this script, the headers of each of the state files in the ACLF dataset are modified to remove invalid characters including whitespaces ( ), hyphens (-), and forward slashes (/). The column headers are also converted to lowercase. 

# Author: Josiah Sparks
# Date: 29 Aug 2024

INPUT_DIR="./Raw Data/ACLF_States"
OUTPUT_DIR="./Data/ACLF_States"
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

for state in "${states[@]}"; do
  input_file="$INPUT_DIR/${state}.csv"
  output_file="$OUTPUT_DIR/${state}.csv"
  if [ ! -f "$input_file" ]; then
    echo "File $input_file does not exist."
    exit
  fi
  first_line=$(head -n 1 "$input_file" | sed 's/[- /]/_/g' | tr '[:upper:]' '[:lower:]')
  rest_of_file=$(tail -n +2 "$input_file")
  {
    echo "$first_line"
    echo "$rest_of_file"
  } > "$output_file"
  echo "Processed ${state}"
done




