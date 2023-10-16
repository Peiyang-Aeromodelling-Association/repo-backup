#!/usr/bin/bash

# read key_dir from 1st argument
key_dir=$1

# function load_key: load ssh key from key_dir via repo name, return content of the key
function load_key {
  key_name=$1
  key_path=$key_dir/$key_name
  if [ -f "$key_path" ]; then
    echo $key_path
  else
    echo "Key $key_name not found in $key_dir"
    exit 1
  fi
}

# Set the repository URL
repo_url=git@github.com:Peiyang-Aeromodelling-Association/repo-backup.git

# Set the local destination for the repository
local_destination=~/Peiyang-Aeromodelling-Association

# Clone the repository if it doesn't already exist (.git doesn't exist)
if [ ! -d "$local_destination/.git" ]; then
  GIT_SSH_COMMAND="ssh -i $(load_key repo-backup)" git clone $repo_url $local_destination
fi

# Navigate to the local repository directory
cd $local_destination

# git pull documentation-deploy
GIT_SSH_COMMAND="ssh -i $(load_key repo-backup)" git pull origin main:main --force

function pull_submodule {
  submodule_name=$1
  submodule_path=$local_destination/$submodule_name
  if [ -d "$submodule_path" ]; then
    echo "Pulling $submodule_name"
    cd $submodule_path
    GIT_SSH_COMMAND="ssh -i $(load_key $submodule_name)" git fetch --all && git reset --hard origin/HEAD
    cd $local_destination  # return to local_destination
  else
    echo "Submodule $submodule_name not found in $local_destination"
    exit 1
  fi
}

# list all submodules, for each submodule, set ssh key and pull, ssh key is the repo name
submodule_names=$(git submodule | awk '{print $2}')
for submodule_name in $submodule_names; do
  # if submodule is not initialized (.git not exist), init it
  if [ ! -e "$local_destination/$submodule_name/.git" ]; then
    echo "Cloning $submodule_name"
    GIT_SSH_COMMAND="ssh -i $(load_key $submodule_name)" git submodule update --init $submodule_name
  fi
  pull_submodule $submodule_name
done

# commit and push changes
git add . && git commit -am"update" && GIT_SSH_COMMAND="ssh -i $(load_key repo-backup)" git push origin main

