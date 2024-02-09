#!/bin/bash

# Return the named setting from `package.json`
# @param $1 The setting to retrieve
read_setting() {
    setting=$1
    echo $(node --eval "console.log(require('./package.json').${setting});")
}

# Return the name of the project given the contents of the `package.json` file
# TODO: Generalize this to accept a file name and a key path
project_name() {
    read_setting name
}

# Return the auth file suffix used in this project
auth_file_suffix() {
    read_setting authFileSuffix
}

# Return the auth directory used in this project
auth_dir() {
    read_setting authDir
}

# Return the standard Dev Hub name given the project name
devhub_name() {
    echo "$(project_name)DevHub"
}

# Return the standard production org name
prod_name() {
    echo "$(project_name)Pro"
}

# Return the standard QA org name
qa_name() {
    echo "$(project_name)QA"
}

# Return the standard scratch org name
scratch_name() {
    echo "$(project_name)Scratch"
}

# Check the passed exit code and dsiplay the appropriate message based on it, exiting if
# there's an error
# @param $1: The exit code of the previously executed command
# @param $2: The success message
# @param $3: The error message
check_error() {
    exitCode=$1
    failMsg=$2
    successMsg=$3
    echo
    if [ "${exitCode}" != 0 ]; then
        echo_error "ERROR: ${failMsg}"
        exit -1
    fi
    echo_success "SUCCESS: ${successMsg}"
}

# Echo the text in the given color.
# @param $1: The expression to echo
# @param $2: The color to use
echo_color() {
    local exp=$1;
    local color=$2;
    if ! [[ $color =~ '^[0-9]$' ]] ; then
        case $(echo $color | tr '[:upper:]' '[:lower:]') in
            black) color=0 ;;
            red) color=1 ;;
            green) color=2 ;;
            yellow) color=3 ;;
            blue) color=4 ;;
            magenta) color=5 ;;
            cyan) color=6 ;;
            white|*) color=7 ;; # white or invalid color
        esac
    fi
    tput setaf $color;
    echo $exp;
    tput sgr0;
}

# Echo in a color that indicates important information
# @param $1: The expression to echo
echo_info() {
    echo_color "${1}" blue
}

# Echo in a color that indicates success
# @param $1: The expression to echo
echo_success() {
    echo_color "${1}" green
}

# Echo in a color that indicates an error
# @param $1: The expression to echo
echo_error() {
    echo_color "${1}" red
}

# Read the password from password if it exists and echo it for the caller. Otherwise prompt
# the user for the password and write it to password.txt
# @note Echoes to stderr so the final password can be echoed up to the caller
retrieve_password() {
    if [ -f password.txt ]; then
        password=$(head -n 1 password.txt)
    else
        read -p "Enter password to encrypt and decrypt auth files: " password
        echo "${password}" > password.txt
    fi
    echo "${password}"
}

# Use the password to encrypt the file into the `secrets` directory with `.secrets` appended
# to the original filename. @param $1: The name of the file (assumed to be in the `secrets`
# directory) @param $2: An optional password
encode() {
    if [ -n "${2}" ]; then
        password=${2}
    else
        password=$(retrieve_password)
    fi
    openssl enc -aes-256-cbc -md md5 -k ${password} -in ${1} -out ${1}.enc
    check_error ${?} "Problem encrypting the auth file. Please verify that ${1} exists." \
        "Auth file encrypted."
}

# Purpose:    Use the password to decrypt the file with `.enc` appended to the
#             filename into the `secrets` directory.
# @param $1: The name of the file (assumed to be in the `secrets` directory)
# @param $2: An optional password
decode() {
    if [ -n "${2}" ]; then
        password=${2}
    else
        password=$(retrieve_password)
    fi
    openssl enc -d -aes-256-cbc -md md5 -k ${password} -in ${1}.enc -out ${1}
    check_error ${?} "Problem decrypting the auth file. Please double-check your password " \
        "and verify ${1}.enc exists. Auth file encrypted."
}

# Purpose: After a script launches another app, return the focus to the terminal emulator that
#          launched it.
focus_caller() {
    case "${OSTYPE}" in
        darwin*)
            case "${TERM_PROGRAM}" in
                vscode*) open "/Applications/Visual Studio Code.app" ;;
                iTerm*) open "/applications/iTerm.app" ;;
            esac
    esac
}

# Purpose:    Authorize an org and extract the secure URL from the org's description,
#             encrypts the secure URL and password in files excluded from git
# @param $1: The org's alias
# @param $2: The name of the file to store the secure URL
# @param $3: The type of org being authed
# @param $4: An optional password
auth_org() {
    orgAlias=$1
    authFile=$2
    orgType=$3
    password=$4

    echo_info "Authenticating to ${orgType} org..."
    if [ ${orgType} != "QA" ]; then
        sfdx force:auth:web:login -a ${orgAlias}
    else
        sfdx force:auth:web:login -a ${orgAlias} -r "https://test.salesforce.com"
    fi
    check_error ${?} "Authorization with the ${orgAlias} org failed." \
        "Authenticated to project ${orgType} org."
    focus_caller

    echo_info "Creating Dev Hub authentication file..."
    # sfdx force:org:display -u ${orgAlias} --verbose --json > ${authFile}
    sfdx force:org:display -u ${orgAlias} --verbose \
        | grep "Sfdx Auth Url" \
        | sed -E 's/^ Sfdx Auth Url[[:blank:]]*(.*)$/\1/' > ${authFile}
    check_error ${?} "Problem access ${orgAlias} org details." \
        "Authentication file created as ${authFile}."

    encode ${authFile} ${password}
    echo_info "The auth file has been encrypted at ${authFile}.enc" && echo
}

# Purpose:   Create the named branch if it doesn't exist and check it out
# @param $1: The name of the branch
create_branch() {
    branchName=${1}
    git show-ref --verify --quiet refs/heads/${branchName}
    if [ ${?} = "0" ]; then
        echo_error "ERROR: branch already exists"
        exit -1
    fi
    if [ $(git branch --show-current) != "dev" ]; then
        echo_info "Checking out dev branch before creating ${branchName}"
        git checkout dev
    fi
    git checkout -b "${branchName}"
}
