#!/bin/bash
# (this script is meant to run as cronjob)
set -e

if [ $# -ne 1 ] ; then
    echo "usage: $0 <path_to_git_repository>"
    exit 1
fi

tag="last_email"

cd "$1"
export GIT_PAGER=""

git fetch origin

echo "new commits (oldest first):"
echo
if git log --reverse --oneline $tag..origin/master ; then
    echo "details (oldest first):"
    git log --reverse -p --stat $tag..origin/master
else
    echo "Hm, tag $tag does not exist yet?"
    echo "I am creating it now. See you later."
fi
git tag -f $tag origin/master

