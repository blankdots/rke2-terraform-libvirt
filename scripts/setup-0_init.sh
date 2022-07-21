#!/bin/bash

TF=terraform

# shellcheck source=setup-1_checks.sh
source ./scripts/setup-1_checks.sh

# shellcheck source=setup-2_generate-key.sh
source ./scripts/setup-2_generate-key.sh

"${TF}" -chdir=./terraform init

