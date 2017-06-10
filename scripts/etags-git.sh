#!/bin/sh

rm -f TAGS
git ls-files | grep -v -E '(xcf|jpg|jpeg|png|svgz|po|svg|gz|bin|dat)$' | xargs -d\\n etags --append

# Hm, does this really help?
#rm -f TAGS
#git ls-files | xargs -d\\n etags -a
