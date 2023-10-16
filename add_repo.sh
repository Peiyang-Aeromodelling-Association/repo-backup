#!/usr/bin/bash

# read key_dir from 1st argument
key_dir=$1
repo_url=$2

repo_name=$(basename "$repo_url" .git)

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

# git submodule add
GIT_SSH_COMMAND="ssh -i $(load_key $repo_name)" git submodule add $repo_url $repo_name
