#!/bin/bash

TF=terraform

TFVAR="-var-file=../terraform.tfvars.json"

# we generate the join_token fresh when we apply and we don't need to see it
# this is just to run the plan
join_token="check_on_apply"

"${TF}" -chdir=./terraform destroy "${TFVAR}" -var="kubernetes_join_token=${join_token}" -auto-approve

if [ -f k8s.yaml ]; then
    rm k8s.yaml
fi
