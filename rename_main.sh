#!/bin/bash

set -x

#grep 'branch "main"' .git/config
#git checkout -b master
#git push -u origin master
#git branch
#git branch -d main
#git push --set-upstream origin master
#git remote set-head origin master

printf 'Did you change the default branch in gitlab and unprotect main (y/n)? '
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then # this grammar (the #[] operator) means that the variable $answer where any Y or y in 1st position will be dropped if they exist.
    echo "Deleting main branch in origin"
    git pull -p
    git push origin --delete main
    cat .git/config
    git branch --all
    # git symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/master
    git branch -r
else
    echo "Not deleting main branch in origin"
fi



