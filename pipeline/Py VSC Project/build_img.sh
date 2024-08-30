#!/ban/bash

CONTAINER_NAME=python-runner
IMAGE_NAME=python-runner-img
NETWORK="datanetwork"

docker build -t $IMAGE_NAME .

#docker run -d \
#--name ${CONTAINER_NAME} \
#--network $NETWORK \
#$IMAGE_NAME
