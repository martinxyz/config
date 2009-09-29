#!/bin/sh
if [ -d .svn ] ; then
  #svn ls -R | xargs etags
  etags $(svn ls -R)
elif [ -d .git ] ; then
  etags $(git ls-files)
  #git ls-files | xargs etags
else
  echo 'No .svn or .git directory found!'
fi

