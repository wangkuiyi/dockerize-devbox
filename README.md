# Dockerize DevBox

[![Build Status](https://travis-ci.com/wangkuiyi/dockerize-devbox.svg?branch=master)](https://travis-ci.com/wangkuiyi/dockerize-devbox)

The purpose of this Dockerfile is to unify daily software development
environments.  We install compilers, editors, and all other tools,
together with their configurations, into a Docker image, so engineers
can run the Docker image (as a container) as their unified development
environment.

To run the pre-built Docker image

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

You can also connect to the container via SSH from Visual Studio Code.  To do
so, you need to

1. Follow [the guide](https://code.visualstudio.com/docs/remote/remote-overview)
   to install the Remote Development extension pack.

2. Add the following section to your SSH configuration file `~/.ssh/config`.

   ```text
   Host docker
      UseKeychain yes
      HostName localhost
      User a
      Port 2222
   ```

Please change the username `a` into your username.  Now, you can type F1 in
Visual Studio Code and type the command `Remote-SSH: Connect to host...`,
choose the host named `docker`, and connect.