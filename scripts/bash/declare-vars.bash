#!/bin/bash

source scripts/bash/utils.bash

apex_setup="$(apex_setup)"
devhub_name="$(devhub_name)"
err_email="$(err_email)"
perm_sets="$(perm_sets)"
pkg_name="$project_name"
pkg_path=$(node --eval "
    console.log(
        require(
            './sfdx-project.json'
    ).packageDirectories[0].path);"
)
pkg_type=$(pkg_type)
project_name="$(project_name)"
sfdx_auth_file="$(auth_dir)/sfdx$(auth_file_suffix)"
