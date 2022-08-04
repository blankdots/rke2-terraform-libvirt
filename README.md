# rke2-terraform

[![Lint](https://github.com/blankdots/rke2-terraform/actions/workflows/tflint.yml/badge.svg)](https://github.com/blankdots/rke2-terraform/actions/workflows/tflint.yml)
[![Scripts linter](https://github.com/blankdots/rke2-terraform/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/blankdots/rke2-terraform/actions/workflows/shellcheck.yml)
[![tfsec](https://github.com/blankdots/rke2-terraform/actions/workflows/tfsec.yml/badge.svg)](https://github.com/blankdots/rke2-terraform/actions/workflows/tfsec.yml)

A repository that creates a RKE2 kubernetes cluster using Terraform.

Out of the box it comes configured with:

- pre-checks all the requirements are met for the setup to run;
- checks kubernetes API is running and nodes are available after apply;
- generating ssh key for `kubernetes` user, to be used to connect to the VMs (instead of password login);
    - makes use of ssh-agent to load key;
    - key is password protected and generated once;
- generating tf.vars file based on template in file `terraform-template.json`;
- exports kubernetes config file to `k8s.yaml` in root folder;
- kubernetes rke2 additions:
    - system-upgrade controller, to be able to run plans from https://docs.rke2.io/upgrade/automated_upgrade/#configure-plans ;
    - custom audit policy to have more precise logging;
    - wireguard added and configured;
    - `automountServiceAccountToken` set to false, by default;
    - iptables configured to restrict traffic between nodes on specific ports. Configuration is persistent on reboot;
    - (optional) mirror for docker hub with username and password can be configured by adding to the `terraform-template.json`:
        ```json
        "registry_mirror": "mirror.example.com",
        "registry_mirror_user": "example",
        "registry_mirror_pass": "example"
        ```


## Usage

### Creating kuberentes cluster

```bash
# generate keys and load terraform modules
make init

# create plan based on template (need to run once)
make plan

# apply configuration
make apply
```

On `make init` new ssh keys are generated only if they don't exist, and the password is generated once. If the keys want to be reused and the key has been removed from the ssh-agent, `export SSH_PASS=<key>` needs to be used for the `make init` to know how to add the keys to the ssh-agent.


### Destroy kubernetes cluster

```bash
# destroy cluster

make destroy
```

## License

MIT License

Code forked from https://github.com/hoeghh/rke2-terraform/ which is licensed under MIT License