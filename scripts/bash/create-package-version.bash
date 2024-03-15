#!/bin/bash

# Generates a new version of a package, creating it if needed, and optionally installing it
# into a new scratch org.

set -e
source scripts/bash/utils.bash

project_name="$(project_name)"
pkg_name="$project_name"
devhub_name="$(devhub_name)"
err_email="$(err_email)"
pkg_path=$(node --eval "console.log(require('./sfdx-project.json').packageDirectories[0].path);")
pkg_type=$(pkt_type)

if [[ ! -d "$pkg_path" ]]; then
    echo && echo_error "Package directory ${pkg_path} does not exist!"
    exit 1
fi

if ! grep "\"$pkg_name\":" sfdx-project.json; then
    echo "Creating the package ${PKG_NAME}."
    echo && echo_info "Create the package ${pkg_name}."
    if [ "$pkg_type" == 'Unlocked' ]; then
        sf package create \
            --target-dev-hub ${devhub_name} \
            --name "$pkg_name" \
            --error-notification-username "$err_email" \
            --package-type "$pkg_type" \
            --path "$pkg_path" \
            --no-namespace
    else
        sf package create \
            --target-dev-hub ${devhub_name} \
            --name "$pkg_name" \
            --error-notification-username "$err_email" \
            --package-type "$pkg_type" \
            --path "$pkg_path"
    fi
fi
