#!/bin/sh
git ls-files | grep -v -E '(xcf|jpg|jpeg|png|svgz|po|svg|gz)$' | xargs -d\\n etags

# Hm, does this really help?
#rm -f TAGS
#git ls-files | xargs -d\\n etags -a
