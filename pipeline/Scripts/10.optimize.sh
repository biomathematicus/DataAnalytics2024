#!/ban/bash

# This script executes PostgreSQL scripts that perform database normalization and optimization. 

# Author: Josiah Sparks
# Date: 29 Aug 2024

CONTAINER_NAME=postgres-db
POSTGRE_USR=postgres

HMDA_SCRIPT="optimize_hmda.sql"
ACLF_SCH_SCRIPT="optimize_aclf_and_sch.sql"
SAIPE_SDGR_SCRIPT="optimize_saipe_and_sdgr.sql"

run_in_container() {
  local SCRIPT_NAME=$1

  docker cp "./Scripts/$SCRIPT_NAME" \
  ${CONTAINER_NAME}:/home

  winpty docker exec ${CONTAINER_NAME} bash

  winpty docker exec ${CONTAINER_NAME} psql -U postgres -f "./home/$SCRIPT_NAME"
}

echo "Optimizing HMDA table"
run_in_container $HMDA_SCRIPT

echo "Optimizing ACLF and SCH tables"
run_in_container $ACLF_SCH_SCRIPT

echo "Optimizing SAIPE and SDGR tables"
run_in_container $SAIPE_SDGR_SCRIPT



