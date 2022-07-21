#!/bin/bash

TF=terraform

TFVAR="-var-file=../terraform.tfvars.json"

# we generate the join_token fresh and we don't need to see it
join_token="$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)"

"${TF}" -chdir=./terraform apply "${TFVAR}" -var="kubernetes_join_token=${join_token}" -auto-approve