# Dockerize DevBox

[![Build Status](https://travis-ci.com/wangkuiyi/dockerize-devbox.svg?branch=master)](https://travis-ci.com/wangkuiyi/dockerize-devbox)

This project defines a Dockerfile to unify daily software development
environments.  By installing development tools into a Docker image, engineers
can run the Docker image as a container as their unified development
environment.

- This Docker image has a non-root user `a` with password `a`.
- This Docker image contains OpenSSH server.  You can SSH into the container as user `a`.
- You can run the `docker` command in the container.
- You can sudo in the container.

TODO:

- Access CUDA on the host from the container.

## Qucik Start

To run the pre-built Docker image, type the following command.

```bash
docker run --rm -d --name dev -p 2222:22 \
 -v /var/run/docker.sock:/var/run/docker.sock \
 -v $HOME/.ssh:/home/a/.ssh \
 -v $HOME/work:/home/a/work \
 cxwangyi/devbox
```

Please be aware that the default user and password are all "a".

To SSH into the container and work on files in $HOME/workspace on
the host:

```bash
ssh a@localhost -p 2222
```

You should be able to run Docker commands in the container.

```bash
sudo docker version
```

## Use Cases

1. You can run the container on a remote development server, and connect to the container via SSH from your Visual Studio Code running on a laptop computer.  For details, please refer to [this page](https://github.com/wangkuiyi/dockerize-devbox/wiki/Use-DevBox-Container-with-Visual-Studio-Code).
