#!/bin/bash

source scripts/bash/utils.bash

project_name="$(project_name)"
devhub_name="$(devhub_name)"
sfdx_auth_file="$(auth_dir)/sfdx$(auth_file_suffix)"

echo && echo_info "Authorizing you with the ${project_name} Dev Hub org..." && echo
sf auth sfdxurl store \
    --sfdx-url-file ${sfdx_auth_file} \
    --set-default-dev-hub \
    --alias ${devhub_name}
check_error ${?} "Can't authorize you with the ${project_name} Dev Hub org!" \
    "Successfully authorized you with the ${project_name} Dev Hub org." \

echo && echo_info "Building your scratch org, please wait..."
sf org create scratch \
    --target-dev-hub ${devhub_name} \
    --definition-file config/project-scratch-def.json \
    --set-default \
    --alias ${project_name} \
    --duration-days 21
check_error ${?} "Can't create your org!" \
    "Successfully created your scratch org." \

echo && echo_info "Pushing source to the scratch org. This may take a while, so now might " \
    "be a good time to stretch your legs and/or grab your productivity beverage of choice..." \
    && echo
sf project deploy start
check_error ${?} "Pushing source to the scratch org failed!" \
    "Source pushed successfully to scratch org."

for directory in "Dev" "Mock" "Scratch"
do
    lower=$(node --eval "console.log('${directory}'.toLowerCase());")
    echo && echo_info "Pushing ${lower} source to the scrath org..." && echo
    sf project deploy start --source-dir "force-${lower}"
    check_error ${?} "Pushing ${lower} source to the scratch org failed!" \
        "${directory} source pushed successfully to scratch org."
done
