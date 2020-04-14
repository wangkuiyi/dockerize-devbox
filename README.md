The purpose of this Dockerfile is to unify daily software development
environments.  We install compilers, editors, and all other tools,
together with their configurations, into a Docker image, so engineers
can run the Docker image (as a container) as their unified development
environment.

To build the Docker image:

```bash
docker build --build-arg USER=$USER -t dev .
```

To run a Docker container given the image:

```bash
docker run --rm -d --name dev -p 2222:22 \
 -v /var/run/docker.sock:/var/run/docker.sock \
 -v $HOME/.ssh:/home/$USER/.ssh \
 -v $HOME/work:/home/$USER/work \
 dev
```

To SSH into the container and work on files in $HOME/workspace on
the host:

```bash
ssh localhost -p $(docker port dev 22 | cut -f 2 -d ':')
```

You should be able to run Docker commands in the container.  For example:

```bash
sudo docker version
```
