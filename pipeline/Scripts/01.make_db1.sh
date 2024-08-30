#!/ban/bash

# This script creates the PostgreSQL container
# The SQL script, mk_tbl.sql, creates the schemas data_schema and ref_schema

# Author: Josiah Sparks
# Date: 29 Aug 2024

CONTAINER_NAME=postgres-db
POSTGRE_USR=postgres
POSTGRE_PWD=pwd123

NETWORK="datanetwork"
if docker network inspect ${NETWORK} > /dev/null 2>&1
then
    echo "Network '${NETWORK}' already exists"
    #docker network rm ${NETWORK}
fi

docker network create ${NETWORK} > /dev/null

docker run -d \
--name ${CONTAINER_NAME} \
--network $NETWORK \
-p 5432:5432 \
-e POSTGRES_PASSWORD=$POSTGRE_PWD \
postgres

# -v "$(pwd)/Data":"/mounted_data" \

until docker exec ${CONTAINER_NAME} pg_isready -U ${POSTGRE_USR} -h ${CONTAINER_NAME} -p 5432 -q; do
    >&2 echo "PostgreSQL is unavailable - waiting"
    sleep 1
done

winpty docker exec ${CONTAINER_NAME} psql -U $POSTGRE_USR

docker cp "./Scripts/mk_tbl.sql" ${CONTAINER_NAME}:/home
winpty docker exec ${CONTAINER_NAME} bash

winpty docker exec ${CONTAINER_NAME} psql -U postgres -f "./home/mk_tbl.sql"


