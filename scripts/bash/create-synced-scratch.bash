#1/bin/bash

# Executes the start script to create a scratch org and push the source code, but then (while
# perhaps returning the user to the calling terminal) takes note of the current git branch,
# creates an alias to the default org that is the same as that branch, allowing the use of
# `npm run checkout` to move simultaneously between branches and matching orgs.`

set -e
source scripts/bash/utils.bash

npm run start
focus_caller
branch=$(git branch --show-current)
org=$(sf org display --json \
    | grep -o '"username": "[^"]*' \
    | grep -o '[^"]*$')
sf alias set ${branch}=${org}
npm run checkout ${branch}
