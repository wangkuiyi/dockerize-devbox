#!/bin/sh

sudo apt-get -qq install -y python3 python3-pip

echo "alias python='python3'" >> ~/.bashrc
echo "alias pip='pip3'" >> ~/.bashrc