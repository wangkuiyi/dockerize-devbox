#!/bin/sh

sudo apt-get -qq install -y python3 python3-pip

sudo ln -s $(which python3) /usr/bin/python
sudo ln -s $(which pip3) /usr/bin/pip