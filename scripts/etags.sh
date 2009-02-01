#!/bin/sh
# Runs etags recurisvely on all source files in the current directory.

#--languages=-python
etags -R --exclude=swig --exclude=trainings --exclude=html --exclude='*.asm'
exit $?

