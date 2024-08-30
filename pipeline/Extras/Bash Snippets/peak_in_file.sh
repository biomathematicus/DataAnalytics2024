#!/ban/bash

FILE_NAME="hmda_2017_nationwide_first-lien-owner-occupied-1-4-family-records_labels.csv"

head -3 ${FILE_NAME} | 
while read a; do
  echo $a; 
done

sleep 600