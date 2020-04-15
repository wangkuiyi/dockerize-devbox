#!/bin/sh

set -e
sudo apt-get -qq install -y pandoc graphviz libgraphviz-dev
sudo pip3 -q install pygraphviz --install-option="--include-path=/usr/include/graphviz" --install-option="--library-path=/usr/lib/graphviz/"
sudo pip3 -q install pandocfilters
sudo cp /dockerize-pandoc/pandoc_all.bash /usr/local/bin/
sudo chmod +x /usr/local/bin/pandoc_all.bash
