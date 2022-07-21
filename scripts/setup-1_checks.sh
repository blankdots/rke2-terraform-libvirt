#!/bin/bash

verTerraform="$(terraform version 2>&1 | awk 'NR==1' | awk '{print $2}')"
versionNeeded="v1.2.5"

command -v terraform >/dev/null 2>&1 || { echo "terraform required but it's not installed. Aborting." >&2; exit 1; }

# We pin the version so that we don't have issues with changes in terraform
if [ "${verTerraform}" != $versionNeeded ]; then
    echo "terraform does not have the required version, current version is ${verTerraform} and required is: ${versionNeeded}"
    exit 1
fi

# We need this to generate the terraform.tfvars.json
command -v jq >/dev/null 2>&1 || { echo "jq required but it's not installed. Aborting." >&2; exit 1; }

# we need to this to add the password automatically to the ssh agent
command -v expect >/dev/null 2>&1 || { echo "expect required but it's not installed. Aborting." >&2; exit 1; }