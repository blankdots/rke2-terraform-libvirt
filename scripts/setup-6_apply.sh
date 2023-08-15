#!/bin/bash

TF=terraform

TFVAR="-var-file=../terraform.tfvars.json"

if [ ! -f terraform.tfvars.json ]; then
    echo "run make plan to generate the require variables file: terraform.tfvars.json"
    exit 1
fi

ubuntu_img=https://cloud-images.ubuntu.com/releases/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img

IMG_DIR="${PWD}/img"
if [ ! -d "${IMG_DIR}" ]; then
    mkdir "${IMG_DIR}"
fi

if [ ! -f "${IMG_DIR}/ubuntu-22.04-server.kvm.img" ]; then
    wget --no-check-certificate -O "${IMG_DIR}/ubuntu-22.04-server.kvm.img" "${ubuntu_img}"
fi

# we generate the join_token fresh and we don't need to see it
join_token="$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)"

"${TF}" -chdir=./terraform apply "${TFVAR}" -var="kubernetes_join_token=${join_token}" -auto-approve

master_ip=$(jq -r '.kubernetes_server_ips[0]' terraform.tfvars.json)

if ssh-keygen -F "${master_ip}"; then
    ssh-keygen -R "${master_ip}"
fi

# retrieve kubernetes config file
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no kubernetes@"${master_ip}" \
    cat /etc/rancher/rke2/rke2.yaml | sed "s/127.0.0.1/${master_ip}/" > k8s.yaml

# let us restrict who can access this file
chmod 600 k8s.yaml

# let us wait a bit for the nodes to be set up
sleep 30

# we check against 401 HTTP response as we the default-token secret might differ
# 401 is enough to validate the k8s API is up
timeout 300 bash -c \
    "while [[ '$(curl --insecure -s -o /dev/null -w '%{http_code}\n' https://"${master_ip}":6443)' != '401' ]]; \
    do echo 'Waiting for ${master_ip} master node ...' && sleep 12; done"


echo "K8s API is available, now waiting for cluster nodes to be ready ... "
export KUBECONFIG="${PWD}/k8s.yaml"
kubectl wait --for=condition=Ready nodes --all --timeout=600s

echo "Adding system-upgrade controller, for automatic updates ..."
sleep 10
upgrade_controller_version="v0.13.0"
kubectl apply -f \
    "https://github.com/rancher/system-upgrade-controller/releases/download/${upgrade_controller_version}/system-upgrade-controller.yaml"

echo "Adding wireguard, for in-kernel WireGuard encapsulation and encryption  ..."
sleep 10

kubectl apply -f presets/wireguard.yaml

kubectl apply -f presets/dns_cache.yaml

kubectl rollout restart ds rke2-canal -n kube-system

for namespace in $(kubectl get namespaces -A -o=jsonpath="{.items[*]['metadata.name']}"); do
  echo -n "Patching namespace $namespace - "
  kubectl patch serviceaccount default -n "${namespace}" -p "$(cat presets/account_update.yaml)"
done

echo "=================="
echo "run:"
echo "export KUBECONFIG=\"\${PWD}/k8s.yaml\""
echo "to make the k8s API available in the CLI."
