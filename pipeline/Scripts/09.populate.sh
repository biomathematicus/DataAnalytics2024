#!/ban/bash

# This script copies the extracted and prepared data into the PostgreSQL container and executes a list of scripts that create tables and utilize the COPY command in PostgreSQL to move the data from CSV files into the appropriate tables. 

# Author: Josiah Sparks
# Date: 29 Aug 2024

CONTAINER_NAME=postgres-db
LEA_SCRIPT="pop_lea_tables.sql"
SCH_SCRIPT="pop_sch_tables.sql"
ED_SCRIPT="pop_ed_tables.sql"
SAIPE_SCRIPT="pop_saipe_table.sql"
SLGA_SCRIPT="pop_slga_table.sql"
HMDA_SCRIPT="pop_hmda_table.sql"
SDGR_SCRIPT="pop_sdgr_tables.sql"
ACLF_SCRIPT="pop_aclf_table.sql"

echo "Copying data into container..."
docker cp "./Data" postgres-db:/home

run_in_container() {
  local SCRIPT_NAME=$1

  docker cp "./Scripts/$SCRIPT_NAME" \
  ${CONTAINER_NAME}:/home

  winpty docker exec ${CONTAINER_NAME} bash

  winpty docker exec ${CONTAINER_NAME} psql -U postgres -f "./home/$SCRIPT_NAME"
}

echo "Populating LEA tables"
run_in_container $LEA_SCRIPT

echo "Populating SCH tables"
run_in_container $SCH_SCRIPT

echo "Populating ED tables"
run_in_container $ED_SCRIPT

echo "Populating SAIPE table"
run_in_container $SAIPE_SCRIPT

echo "Populating SLGA table"
run_in_container $SLGA_SCRIPT

echo "Populating HMDA table"
run_in_container $HMDA_SCRIPT

echo "Populating SDGR tables"
run_in_container $SDGR_SCRIPT

echo "Populating ACLF table"
run_in_container $ACLF_SCRIPT
