#!/bin/bash
# where current script is located
self_path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# create sample config file, if none exists
if [ ! -f $self_path/.pushgit.conf ]
then
    touch $self_path/.pushgit.conf
    echo "Please edit the (hidden) file $self_path/.pushgit.conf (notice the leading '.') to match your github account data"
    echo 'user="github_username"\nemail="github_email_address"\ntoken="github_access_token"' >> .pushgit.conf
fi


# sourcing the config file
. $self_path/.pushgit.conf

# removing last char from config variables
#user=${user%?}
#email=${email%?}
#token=${token%?}

# set user name and email in global config once
if ! git config --list | grep -q $user; then
git config --global user.name "$user"
git config --global user.email "$email"
fi

# enter repo's name
echo 'Please specify the repositories name:'
read repo_name

# check if the repo's directory exists in current folder on the local machine, otherwise clone it here
if [ -d "$self_path/../$repo_name" ];
then
    echo "Target directory $repo_name already exists, skipping initial clone"
else
    echo "Cloning repo $repo_name into target directory $(pwd)/$repo_name"
    cd $self_path/..
    git clone https://$user:$token@github.com/$user/$repo_name.git
fi

# change dir to repositories local directory
cd $self_path/../$repo_name

# add all files from repo's local directory to git repo
git add .
git add ./*

# specify a commit message
echo 'Enter the commit message:'
read commitMessage
git commit -m "$commitMessage"

# echo 'Enter branch name:'
# read branch

# commit repo's local directory to github
URL="https://${user}:${token}@github.com/${user}/${repo_name}.git"

git push "${URL}" main #branch
