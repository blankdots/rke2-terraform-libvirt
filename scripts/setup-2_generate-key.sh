#!/bin/bash

NAME=kubernetes_key

KEYS_DIR="${PWD}/keys"
if [ ! -d "${KEYS_DIR}" ]; then
    mkdir "${KEYS_DIR}"
fi

PRIK="${KEYS_DIR}/${NAME}"
PUBK="${KEYS_DIR}/${NAME}.pub"

# Do not overwrite key if it exists

if [ -f "${PRIK}" ] || [ -f "${PUBK}" ]; then
	echo "Key already exists, we are not overwriting it."
else 
    echo "Generating new key ..."
    PASS=$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    ssh-keygen -t ed25519 -C "k8s" -f "${KEYS_DIR}/${NAME}" -P "${PASS}"

    echo "===="
    echo "Generated Password for the key is: ${PASS}"
    echo "keep it safe it will dissappear once the shell is closed."
    echo "===="
fi

if  ssh-add -l | grep -q "$(ssh-keygen -lf "${PRIK}" | awk '{print $2}')"; then 
    echo "key is already in the agent.";
else 
    # shellcheck source=setup-3_add-key-agent.sh
    source ./scripts/setup-3_add-key-agent.sh "${NAME}" "${KEYS_DIR}" "${PASS}"
fi



