#!/bin/bash

if [ -f terraform.tfvars.json ]; then
	echo "configuration file already exists, we are not overriding it."
    echo "Delete the configuration and run again to generate a fresh one"
else 
    NAME=kubernetes_key

    KEYS_DIR="${PWD}/keys"
    if [ ! -d "${KEYS_DIR}" ]; then
        echo "run make init to generate the keys"
        exit 1
    fi

    PUBK="${KEYS_DIR}/${NAME}.pub"

    jq \
        --arg kubernetes_node_public_key_path "${PUBK}" \
        --arg os_image "${PWD}/img/ubuntu-20.04-server.kvm.img" \
        '. |= . + {
            "os_image": $os_image,
            "kubernetes_node_public_key_path": $kubernetes_node_public_key_path
        }' terraform-template.json | sponge terraform.tfvars.json
fi
