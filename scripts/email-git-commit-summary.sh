#!/bin/bash
# (this script is meant to run as cronjob)

(
set -e

if [ $# -ne 2 ] ; then
    echo "usage: $0 <path_to_git_repository> <email subject>"
    exit 1
fi

tag="last_email"

cd "$1"
export GIT_PAGER=""

git fetch origin

echo "new commits (oldest first):"
echo
if git log --reverse --oneline $tag..origin/master . ; then
    echo
    #echo "details (oldest first):"
    #git log --reverse -p --stat $tag..origin/master
    echo "Active Authors:"
    git shortlog -n -s $tag..origin/master .
else
    echo
    echo "Hm, tag $tag does not exist yet?"
    echo "I am creating it now. See you later."
fi
git tag -f $tag origin/master

) > /tmp/commits$$.txt 2>&1

mail -s "[commits] $2" martin < /tmp/commits$$.txt

