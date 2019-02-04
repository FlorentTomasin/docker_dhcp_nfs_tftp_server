#!/bin/bash

source .env

docker run -ti --privileged --name=nfs \
--network=host \
-v /${NFS_DIR}:/nfs \
${DOCKER_IMAGE}:${DOCKER_TAG}

# Uncomment if you want to manually map the port and don't use 
# the host network
# -p ${PORT_111_TCP}:111/tcp \
# -p ${PORT_111_UDP}:111/udp \
# -p ${PORT_2049_TCP}:2049/tcp \
# -p ${PORT_2049_UDP}:2049/udp \
