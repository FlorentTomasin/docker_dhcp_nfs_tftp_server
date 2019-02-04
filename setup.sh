#!/bin/bash

source .env

echo "${0}: Build the docker images: ${DOCKER_IMAGE}:${DOCKER_TAG}"
docker build --rm --compress -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
