#!/usr/bin/env bash

# Purpose:    Swap branches and orgs at the same time
# Parameters: $1: The name of the branch and org to swap to
# Version:    21-08-11 - Chuck Ross
#             21-10-07 - Chuck Ross - Add git pull and sfdx push
#             21-10-21 - Chuck Ross - Add set git upstream

set -e
branch=${1}
git checkout "${branch}"
sfdx force:config:set defaultusername="${branch}"
sfdx force:source:push --loglevel fatal --forceoverwrite
