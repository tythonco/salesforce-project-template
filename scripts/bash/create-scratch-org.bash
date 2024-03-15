#!/bin/bash

# Uses settings found in `package.json` to create a scratch org, push potential source folders
# to it, import data from the `data` directory, execute anonymous Apex if the `setup.apex` file
# exists, and finally opens the new scratch org for the developer.

set -e
source scripts/bash/utils.bash

project_name="$(project_name)"
devhub_name="$(devhub_name)"
sfdx_auth_file="$(auth_dir)/sfdx$(auth_file_suffix)"
apex_setup="$(apex_setup)"
perm_sets="$(perm_sets)"

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
for name in "App" "Dev" "Mock" "Scratch"; do
    lower=$(node --eval "console.log('${name}'.toLowerCase());")
    dir="force-${lower}"
    if [ -d $dir ]; then
        echo && echo_info "Pushing ${lower} source to the scrath org..." && echo
        sf project deploy start --source-dir "${dir}" > /dev/null
        check_error ${?} "Pushing ${lower} source to the scratch org failed!" \
            "${name} source pushed successfully to scratch org."
    fi
done

if [ -d data ] && [ ! -z "$(ls -A data)" ]; then
    echo && echo_info "Beginning import from data directory..." && echo
    files=$(ls -1 data/*| paste -sd "," -)
    sf data import tree --files "${files}" > /dev/null
    check_error ${?} "Importing default data to the scratch org failed!" \
        "Default data was successfully imported into the scratch org."
fi

if [ -f "scripts/apex/${apex_setup}" ]; then
    echo && echo_info "About to execute ${apex_setup}..." && echo
    sf apex run --file "scripts/apex/${apex_setup}" > /dev/null
    check_error ${?} "${apex_setup} execution failed!" \
        "Successfully executed ${apex_setup}"
fi

perm_sets="Test_Permissions_Assignment"
if ["$perm_sets" = ""]; then
    echo && echo_info "Assigning perm sets to user..." && echo
    for perm_set in ${perm_Sets}; do
        sf org assign permset --name "${perm_set}" > /dev/null
        check_error ${?} "Error assigning perm set ${perm_set}" \
            "Successfully assigned ${perm_set}"
    done
fi

sf project reset tracking --no-prompt
echo && echo_info "Opening scratch org for develoopment, may the flow be with you!" && echo
sleep 3
sf org open
