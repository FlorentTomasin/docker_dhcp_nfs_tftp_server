#!/bin/bash

source env.conf

if [[ ${USE_PORT_MAPPING} != 0 ]]; then
    DOCKER_NETWORK="-p ${PORT_111_TCP}:111/tcp \
                    -p ${PORT_111_UDP}:111/udp \
                    -p ${PORT_2049_TCP}:2049/tcp \
                    -p ${PORT_2049_UDP}:2049/udp \
                    -p ${PORT_67_TCP}:67/tcp \
                    -p ${PORT_67_UDP}:67/udp \
                    -p ${PORT_69_UDP}:69/udp"
    echo "${0}: Using Docker port mapping."
else
    DOCKER_NETWORK="--network=host"
    echo "${0}: Using Docker Host network mode."
fi

# --name=nfs
docker run --rm -ti --privileged \
${DOCKER_NETWORK} \
-v ${NFS_DIR}:/nfs \
-v ${TFTP_DIR}:/var/tftpboot \
-v ${PWD}/etc/exports:/etc/exports \
-v ${PWD}/etc/dhcp/dhcpd.conf:/etc/dhcp/dhcpd.conf \
-v ${PWD}/etc/network/interfaces:/etc/network/interfaces \
${DOCKER_IMAGE}:${DOCKER_TAG}
