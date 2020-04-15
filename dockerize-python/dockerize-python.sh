#!/bin/sh

sudo apt-get -qq install -y python3 python3-pip

# NOTE: alias python=python3 doesn't work, because some Python script files
#       might have shebang like #!/usr/bin/env python, where the python
#       must be a file or symlink other than an alias.
sudo ln -s $(which python3) /usr/bin/python
sudo ln -s $(which pip3) /usr/bin/pip
