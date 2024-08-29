#!/ban/bash

NETWORK="datanetwork"
if docker network inspect ${NETWORK} > /dev/null 2>&1
then
    echo "Network '${NETWORK}' already exists"
    #docker network rm ${NETWORK}
fi

docker network create ${NETWORK} > /dev/null

(cd "./Py VSC Project" && sh build_img.sh)

pwd

echo "Completed"
read -p "Press [Enter] key to exit..."