#!/bin/bash

# Allows the user to swap git branches and SFDX scratch orgs at the same time.
# @param $1 The name of the branch and scratch org alias to switch to

set -e
branch=${1}
git checkout "${branch}"
sf config set target-org "${branch}"
sf project deploy start
