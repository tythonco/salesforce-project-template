#!/bin/bash

# One-time script to set up certain prerequisites for the project

npm install
sf config set org-custom-metadata-templates=templates

if [ ! $(basename ${SHELL}) = "zsh" ]; then
    file="${HOME}/.zshrc"
else
    file="${HOME}/.bashrc"
fi

first_alias=$(head -1 scripts/bash/aliases.bash)
if grep -q "$first_alias" "$file"; then
    cat scripts/bash/aliases.bash >> $file
fi
