ARG FROM_IMAGE=ubuntu:20.04
FROM $FROM_IMAGE

# By default, we work as the root user in Docker containers.  Doing
# so, new files created in the container and mapped to the host
# filesystem would have owner root.  We want the file owner to be
# $USER on the host.  To achive this goal, we need to create $USER in
# the Docker image.  We define Docker bulid argument USER here, so
# that we can run the following command to pass in $USER of the host
# to the Docker image:
#
# docker build --build-arg USER=$USER ...
ARG USER=a

# We don't necessarily need $USER in the container to have the same
# uid and gid as she has on the host, so we provide the following
# default values; however, if you want, you can pass in the uid and
# gid from the host.
#
# docker build --build-arg USER_ID=$(id -u) \
#              --build-arg GROUP_ID=$(id -g)
ARG USER_ID=1001
ARG GROUP_ID=1001
ARG HOME=/home/$USER

# Now, create user (and its uid and gid) in the Docker image.
RUN addgroup --gid $GROUP_ID $USER
RUN adduser --home $HOME --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID $USER

# As we are no longer root but $USER in the container, to do
# priviliged operations like installing packages, we need the command
# sudo.  Let's install it.
RUN apt-get update && apt-get install -y sudo

# When we run the sudo command, it would prompt for the password of
# $USER.  Let's give a password "a" to $USER in the container.
RUN echo "$USER:a" | chpasswd

# To make $USER a sudoer, who can run sudo, we need to add her to the
# group sudo.
RUN usermod -aG sudo $USER

# Also, to enable $USER to run docker commands in the container, we
# need to add her to the group docker.  More than that, we need to
# bind the Docker server's socket file from /var/run/docker.sock on
# the host into the container when we start it.
#
# docker run -v /var/run/docker.sock:/var/run/docker.sock
RUN groupadd docker
RUN gpasswd -a $USER docker

# A step further, we want the sudo command doesn't require and prompt
# password from $USER.
RUN echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# With $USER fully set up in the Docker image, we can make it the
# default user now.  Please be aware that we will need the sudo prefix
# for all apt-get install commands in the rest of this Dockerfile,
# because we are no longer root but $USER from here on.
USER $USER

# Of couse, we need to install the docker command in the Docker image.
# Working on Ubuntu <20.0, we need to follow steps in
# https://docs.docker.com/engine/install/ubuntu/; however, with Ubuntu
# 20.04, we only need to run the following command.
RUN sudo apt-get install -y docker.io

# We need to install SSH server so users could SSH into the Docker
# container.  This makes it easy to run the container on a powerful
# server and SSH into it from your notebook computer.
# The following commands come from
# https://docs.docker.com/engine/examples/running_ssh_service/
RUN sudo DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server
RUN sudo mkdir /var/run/sshd
RUN sudo sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sudo sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN sudo sh -c 'echo "export VISIBLE=now" >> /etc/profile'
EXPOSE 22
CMD ["sudo", "/usr/sbin/sshd", "-D"]

# As a devbox, we need to install compilers of various languages, pretty 
# printers, editors, etc.  To make it easy to customize, we assme subdirectories
# like dockerize-git, dockerize-emacs, dockerize-python, etc.  The following
# script executes dockerize-*/*.sh in each of these subdirectories.
# Please be aware that the following list implies the execution order.
COPY ./dockerize-bash /dockerize-bash
RUN /dockerize-bash/dockerize-bash.sh

COPY ./dockerize-python /dockerize-python
RUN /dockerize-python/dockerize-python.sh

COPY ./dockerize-go /dockerize-go
RUN /dockerize-go/dockerize-go.sh

COPY ./dockerize-pandoc /dockerize-pandoc
RUN /dockerize-pandoc/dockerize-pandoc.sh