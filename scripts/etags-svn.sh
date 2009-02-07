#!/bin/sh
if [ -d .svn ] ; then
  svn ls -R | xargs etags
elif [ -d .git ] ; then
  git ls-files | xargs etags
else
  echo 'No .svn or .git directory found!'
fi

