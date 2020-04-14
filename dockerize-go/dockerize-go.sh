#!/bin/sh

if ! which curl; then 
    sudo apt-get -qq install -y curl
fi

curl --silent https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz | \
   sudo tar -C /usr/local -xzf -

echo 'export PATH=/usr/local/go/bin:$PATH' >> ~/.bashrc

mkdir $HOME/go
echo "export GOPATH=$HOME/go" >> ~/.bashrc
