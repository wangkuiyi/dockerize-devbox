#!/bin/sh

echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin
docker tag dev cxwangyi/devbox
docker push --silent cxwangyi/devbox