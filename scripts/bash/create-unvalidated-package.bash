#!/bin/bash

source scripts/bash/create-package.bash

echo && echo_info "Create new version of package ${pkg_name} (skipping validation)...
package_ver_id=$(
    sfdx force:package:version:create \
        --target-dev-hub ${devhub_name} \
        --package "$pkg_name" \
        --installation-key-bypass
        --wait 15
    | grep login.salesforce.com \
    | sed -E 's/^.*(04t[[:alnum:]]*)$/\1/'
)
