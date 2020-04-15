#!/bin/bash

if [[ $# == "0" ]]; then
    workspace=$PWD
elif [[ $# == "1" ]]; then
    workspace=$1
else
    echo "Usage: pandoc_all.bash <directory of .md files>"
    exit 1
fi

if [[ ! -d $workspace ]]; then
    echo "$workspace is not a directory"
    exit 2
fi

echo "Converting Markdown files in $workspace ..."
cd "$workspace"

cmd='pandoc -s --mathjax 
         --highlight-style pygments 
         --columns=200 
         --filter ./.graphviz.py '

css=$(du -a . | grep '\.css$' | cut -f 2 | sort | head -n 1)
if [[ -f $css ]]; then
    echo "Using CSS file $css ..."
    cmd="$cmd --css $css"
fi

cat <<EOF > .graphviz.py 
#!/usr/bin/env python
import os
import sys
import pygraphviz
from pandocfilters import toJSONFilter, Para, Image, get_filename4code, get_caption, get_extension, get_value

def graphviz(key, value, format, _):
    if key == 'CodeBlock':
        [[ident, classes, keyvals], code] = value
        if "dot" in classes:
            caption, typef, keyvals = get_caption(keyvals)
            prog, keyvals = get_value(keyvals, u"prog", u"dot")
            filetype = get_extension(format, "png", html="png", latex="pdf")
            dest = get_filename4code("graphviz", code, filetype)
            if not os.path.isfile(dest):
                g = pygraphviz.AGraph(string=code)
                g.layout()
                g.draw(dest, prog=prog)
                sys.stderr.write('Created image ' + dest + '\n')
            return Para([Image([ident, [], keyvals], caption, [dest, typef])])

if __name__ == "__main__":
    toJSONFilter(graphviz)
EOF

chmod +x .graphviz.py

for i in $(du -a . | grep '\.md$' | cut -f 2); do
    target=$(echo $i | sed 's/md$/html/')
    echo $cmd $i -o $target # && echo "Done: $i -> $target" || echo "Failed to convert: $i"
    $cmd $i -o $target # && echo "Done: $i -> $target" || echo "Failed to convert: $i"
done
