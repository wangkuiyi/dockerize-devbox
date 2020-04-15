#!/bin/sh

set -e

sudo apt-get -qq install -y graphviz libgraphviz-dev
sudo pip3 -q install pygraphviz --install-option="--include-path=/usr/include/graphviz" --install-option="--library-path=/usr/lib/graphviz/"

curl --silent --location \
  https://github.com/jgm/pandoc/releases/download/2.9.2.1/pandoc-2.9.2.1-linux-amd64.tar.gz | \
  sudo tar -C /usr/local/ -xzf -
echo 'export PATH=/usr/local/pandoc-2.9.2.1/bin:$PATH' >> $HOME/.bashrc
sudo pip3 -q install pandocfilters

sudo cp /dockerize-pandoc/pandoc_all.bash /usr/local/bin/
sudo chmod +x /usr/local/bin/pandoc_all.bash
