#!/bin/bash

git branch -m master main
git branch --unset-upstream
git remote rename origin old-origin
glab repo create --group limska3/cloudnc
git remote -v
git fetch
git push --set-upstream origin --all
git push --set-upstream origin --tags
  
