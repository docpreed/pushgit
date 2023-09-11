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

# set user name and email in global config once
if ! git config --list | grep -q $user; then
git config --global user.name "$user"
git config --global user.email "$email"
fi

branch_name=''

# if repositorie's name is provided as initial parameter
if [ $# -eq 0 ]
  then
    # enter repo's name
    echo 'Please specify the repositories name:'
    read repo_name

    # specify a commit message
    echo 'Enter the commit message:'
    read commit_message
elif [ $# -eq 1 ]
  then
    repo_name=$1

    # specify a commit message
    echo 'Enter the commit message:'
    read commit_message
elif [ $# -eq 2 ]
  then
    repo_name=$1
    commit_message=$2
elif [ $# -eq 3 ]
  then
    repo_name=$1
    commit_message=$2
    branch_name=$3
elif [ $# > 3 ]
  then
    echo "You provided $# parameters, but expected are a maximum of 3."
    echo "Probably your commit message was not enclosed between \"\""
    echo "Exiting, please try again with \"[your commit message]\""
    exit 0
fi

echo "repository: $repo_name commitmessage: $commit_message"
echo "selfpath: $self_path"

# check if the repo's directory exists in current folder on the local machine, otherwise clone it here
if [ -d "$self_path/../$repo_name" ];
then
    echo "Target directory $repo_name already exists, skipping initial clone"
else
    echo "Cloning repo $repo_name into target directory $(pwd)/$repo_name"
    cd $self_path/../
    git clone https://$user:$token@github.com/$user/$repo_name.git
fi

# change dir to repositories local directory
cd $self_path/../$repo_name

# add all files from repo's local directory to git repo
git add .
git add ./*

git commit -m "$commit_message"

if [ -z "$branch_name" ]
  then
    echo "No branch name specified, using \"main\" branch"
    branch_name="main"
fi

# commit repo's local directory to github
URL="https://${user}:${token}@github.com/${user}/${repo_name}.git"

git push "${URL}" "$branch_name"
