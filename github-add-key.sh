#!/bin/sh

#rm -rf ~/.ssh/id_rsa ~/.ssh/id_rsa.pub
#read -p "Enter github email : " email
#echo "Using email $email"
#ssh-keygen -t rsa -b 2048 -C "$email"
#ssh-add ~/.ssh/id_rsa
pub=`cat ~/.ssh/id_rsa.pub`
read -p "Enter github username: " githubuser
echo "Using username $githubuser"
read -p "Enter github password for user $githubuser: " githubpass
echo curl -u "$githubuser:$githubpass" -X POST -d "{\"title\":\"`hostname`\",\"key\":\"$pub\"}" https://api.github.com/user/keys
curl -u "$githubuser:$githubpass" -X POST -d "{\"title\":\"`hostname`\",\"key\":\"$pub\"}" https://api.github.com/user/keys
