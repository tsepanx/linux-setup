#!/bin/bash

repo_name="linux-setup"
repo_url="https://github.com/tsepanx/$repo_name"

new_dir="$HOME/${repo_name}_$(date +'%Y%m%d_%H%M%S')"
setup_script_location="./setup.sh"

git clone $repo_url "$new_dir"
echo "Entrying repo: $new_dir"
sleep 1

bash "$new_dir"/$setup_script_location
