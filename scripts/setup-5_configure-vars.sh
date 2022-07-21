#!/bin/bash

if [ -f terraform.tfvars.json ]; then
	echo "configuration file already exists, we are not overriding it."
    exit 0
fi 

NAME=kubernetes_key

KEYS_DIR="${PWD}/keys"
if [ ! -d "${KEYS_DIR}" ]; then
    echo "run make init to generate the keys"
    exit 1
fi

PUBK="${KEYS_DIR}/${NAME}.pub"

jq \
    --arg kubernetes_node_public_key_path "${PUBK}" \
    '{
        "kubernetes_pool_path": "/vm-disks/terraform-provider-libvirt-pool-kubernetes",
        "kubernetes_node_public_key_path": $kubernetes_node_public_key_path,
        "kubernetes_node_ssh_username": "kubernetes",
        "kubernetes_server_ips": [
            "10.21.7.10"
        ],
        "kubernetes_server_enable_client": false,
        "kubernetes_server_vcpu": 2,
        "kubernetes_server_memory": 2048,
        "kubernetes_server_disk_size": "16106127360",
        "kubernetes_worker_ips": [
            "10.21.7.20",
            "10.21.7.21"
        ],
        "kubernetes_worker_vcpu": 4,
        "kubernetes_worker_memory": 4096,
        "kubernetes_worker_disk_size": "16106127360"
    }' terraform-template.json | sponge terraform.tfvars.json

