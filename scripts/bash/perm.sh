#!/bin/sh

# IMPORTANT! Replace with the actual project name!
PROJECT_NAME=PermissionsAssistant
ORG_ALIAS="${PROJECT_NAME}Scratch"
DEVHUB_NAME="${PROJECT_NAME}DevHub"
PERMSET_NAME="Permission_Assistant_Access"
TEST_PERMSET_1="PA_Developer_Permission_Set_1"
TEST_PERMSET_2="Mock_Permission_Set_All_Things"
TEST_PERMSET_3="Recipes_Admin"
SFDX_AUTH_URL=sfdx_auth_url.txt

# SAMPLE DATA: Define your sample data, uncomment below while updating comma-separated data file names
# DATA_IMPORT_FILES=data/SomeObjects1.json,data/MySettings.json,data/EtcEtc.json

echo ""
echo "Authorizing you with the ${PROJECT_NAME} Dev Hub org..."
echo ""
sf force:auth:sfdxurl:store -f ${SFDX_AUTH_URL} -d -a ${DEVHUB_NAME} --json
if [ "$?" = "1" ]
then
	echo "ERROR: Can't authorize you with the ${PROJECT_NAME} Dev Hub org!"
	exit
fi
echo "SUCCESS: You've been authorized with the ${PROJECT_NAME} Dev Hub org!"

echo ""
echo "Building your scratch org, please wait..."
echo ""
sf force:org:create -v ${DEVHUB_NAME} -f config/project-scratch-def.json -a ${ORG_ALIAS} -d 21 --json
if [ "$?" = "1" ]
then
	echo "ERROR: Can't create your org!"
	exit
fi
echo "SUCCESS: Scratch org created!"

echo ""
echo "Pushing source to the scratch org! This may take a while! So now might be a good time to stretch your legs and/or grab your productivity beverage of choice..."
echo ""
sf force:source:push -u ${ORG_ALIAS} --json
if [ "$?" = "1" ]
then
	echo "ERROR: Pushing source to the scratch org failed!"
	exit
fi
echo "SUCCESS: Source pushed successfully to the scratch org!"

#echo ""
#echo "Deploying dev artifacts to the scratch org..."
#echo ""
#sfdx force:source:deploy -p force-dev -u ${ORG_ALIAS} --json
#echo ""
#if [ "$?" = "1" ]
#then
#	echo "ERROR: Deploying dev artifacts to the scratch org failed!"
#	exit
#fi
#echo "SUCCESS: Dev artifacts deployed successfully to the scratch org!"

echo ""
echo "Assigning project permission sets to the default scratch org user..."
echo ""
sf force:user:permset:assign -n ${PERMSET_NAME} -u ${ORG_ALIAS} --json
sf force:user:permset:assign -n ${TEST_PERMSET_1} -u ${ORG_ALIAS} --json
sf force:user:permset:assign -n ${TEST_PERMSET_2} -u ${ORG_ALIAS} --json
sf force:user:permset:assign -n ${TEST_PERMSET_3} -u ${ORG_ALIAS} --json
if [ "$?" = "1" ]
then
	echo "ERROR: Assigning a project permission set to the default scratch org user failed!"
	exit
fi
echo "SUCCESS: Project permission sets assigned successfully to the default scratch org user!"

#echo ""
#echo "Importing default data to the scratch org..."
#echo ""
#echo "TODO: Data import!!! Create your sample data and uncomment below!"
# sfdx force:data:tree:import -f ${DATA_IMPORT_FILES} -u ${ORG_ALIAS} --json
#echo ""
#if [ "$?" = "1" ]
#then
#	echo "ERROR: Importing default data to the scratch org failed!"
#	exit
#fi
#echo "SUCCESS: Default data was successfully imported to the scratch org!"

#echo ""
#echo "Running anonymous Apex scripts against the scratch org for additional configuration..."
#echo ""
#echo "TODO: Setup any objects e.g. user roles, if needed! Needs external apex script!"
# sfdx force:apex:execute -f scripts/setup.apex -u ${ORG_ALIAS} --json
#echo ""
#if [ "$?" = "1" ]
#then
#	echo "ERROR: Running anonymous Apex scripts against the scratch org failed!"
#	exit
#fi
#echo "SUCCESS: Successfully ran anonymous Apex scripts against the scratch org!"

sf force:source:tracking:reset -p -u ${ORG_ALIAS}

echo ""
echo "Opening scratch org for development, may the Flow be with you!"
echo ""
sleep 3
sf force:org:open -u ${ORG_ALIAS}
