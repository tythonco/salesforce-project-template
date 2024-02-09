#!/usr/bin/env bash

# Purpose: Create a scratch org, push the source to it, and create some sample data
# Version: 21-07-07 - Chuck Ross

set -e

source scripts/bash/utils.bash

projectName=GEF
devhubName="${projectName}DevHub"
devhubAuth=auth_devhub.txt
devPermsets="GEF_Developer,GEF_Core_User,GEF_Scratch"

echo && echo_info "Authorizing you with the ${projectName} Dev Hub org..." && echo
sfdx force:auth:sfdxurl:store -f ${devhubAuth} -d -a ${devhubName}

echo && echo_info "Building your scratch org, please wait..."
sfdx force:org:create -v ${devhubName} -f config/project-scratch-def.json -s -a ${projectName} -d 21

echo && echo_info "Pushing souce to the scratch org. This may take a while." && echo
sfdx force:source:push >/dev/null
sfdx force:source:deploy -p force-scratch >/dev/null
sfdx force:source:tracking:reset -p

echo && echo_info "Assigning project permission sets to the default scratch org user..."
sfdx force:user:permset:assign -n ${devPermsets} >/dev/null
sfdx force:user:permset:assign -n "GEF_Closer_Manager,GEF_Closer_User" >/dev/null
sfdx force:user:permset:assign -n "GEF_Jr_Loan_Officer,GEF_LO_Manager,GEF_LO_User" >/dev/null
sfdx force:user:permset:assign -n "GEF_LSC_Manager,GEF_LSC_User" >/dev/null
sfdx force:user:permset:assign -n "GEF_PA_Manager,GEF_PA_SUB_User,GEF_PA_SUB2_User" >/dev/null
sfdx force:user:permset:assign -n "GEF_Processor_Manager,GEF_Processor_User" >/dev/null
sfdx force:user:permset:assign -n "GEF_TC_Manager,GEF_TC_User" >/dev/null
sfdx force:user:permset:assign -n "GEF_SA_Manager" >/dev/null

echo && echo_info "Adding sample data to the scratch org..."
sfdx force:apex:execute -f "scripts/apex/create-data.apex" >/dev/null
check_error ${?} "Adding scratch org data via anonymous Apex failed." \
                 "Successfully added data to scratch org via anonymous Apex."

echo && echo_info "Opening scratch org for development." && echo
sleep 2 && sfdx force:org:open
