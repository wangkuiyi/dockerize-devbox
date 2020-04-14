#!/bin/sh

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker tag dev cxwangyi/devbox
docker push cxwangyi/devbox