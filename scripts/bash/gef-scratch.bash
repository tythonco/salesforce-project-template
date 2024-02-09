#!/usr/bin/env bash
source scripts/bash/utils.bash

# Purpose: Create a scratch org, alias it to the current branch, delete the alias
#          created by `start.bash`.
# Version: 21-08-11 - Chuck Ross
#          21-09-09 - Chuck Ross - Ensure branch and alias are same at exit with
#                                  an npm checkout

npm run start
focus_caller
branch=$(git branch --show-current)
org=$(sfdx force:org:display --json | grep -o '"username": "[^"]*' | grep -o '[^"]*$')
sfdx alias:set ${branch}=${org}
npm run checkout ${branch}
