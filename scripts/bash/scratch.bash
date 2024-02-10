#1/bin/bash

source scripts/bash/utils.bash

npm run start
focus_caller
branch=$(git branch --show-current)
org=$(sfdx force:org:display --json | grep -o '"username": "[^"]*' | grep -o '[^"]*$')
sfdx alias:set ${branch}=${org}
npm run checkout ${branch}
