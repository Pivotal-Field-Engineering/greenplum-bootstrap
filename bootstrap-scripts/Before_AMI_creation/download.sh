#!/usr/bin/env bash

# List All keys under ${bucket_name}
# Download all packages,scripts,blueprints
# Download all files under a given $release_name
curl https://s3.amazonaws.com/${bucket_name}/ | \
grep -oE '<Key>[^<]*(\/[^<]+)+<\/Key>' | \
sed -e 's/<[^>]*>//g' |  \
while read key; do
    if [[ ${key} == ${packages_sub_dir}* && -n ${packages_sub_dir} ]]
    then
        echo "${key} matched ${packages_sub_dir}! Downloading..."
        curl -O https://s3.amazonaws.com/${bucket_name}/${key} --fail || exit 1
    elif [[ ${key} == ${scripts_sub_dir}* && -n ${scripts_sub_dir} ]]
    then
        echo "${key} matched ${scripts_sub_dir}! Downloading..."
        curl -O https://s3.amazonaws.com/${bucket_name}/${key} --fail || exit 1
    else
        echo "No idea what ${key} is. Skipped"
    fi
done