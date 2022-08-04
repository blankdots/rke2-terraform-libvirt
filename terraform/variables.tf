### Common configuration ###

variable "os_image" {
  description = "Define the source to the os image used by Kubernetes"
  default     = "https://cloud-images.ubuntu.com/releases/releases/20.04/release/ubuntu-20.04-server-cloudimg-amd64-disk-kvm.img"
}

variable "kubernetes_pool_path" {
  description = "Define the path to libvirt pool"
  default     = "/tmp/terraform-provider-libvirt-pool-kubernetes"
}

variable "kubernetes_node_ssh_username" {
  description = "SSH username on vm"
  default     = "kubernetes"
}

variable "kubernetes_node_public_key_path" {
  description = "Path to public key, must be absolute"
  default     = "/home/user/keys/your_public_key"
}

variable "kubernetes_join_token" {
  description = "Token used to join cluster"
  default     = "secrettoken"
  sensitive   = true
}

### Kubernetes server configuration ###
variable "kubernetes_server_name" {
  description = "The name of the Kubernetes server"
  default     = "k8s-server"
}

variable "kubernetes_server_ips" {
  description = "List of Kubernetes server ip's"
  type        = list(string)
  default     = ["10.21.7.10", "10.21.7.11", "10.21.7.12"]
}

variable "kubernetes_server_enable_client" {
  description = "Enable the client on Kubernetes server"
  type        = bool
  default     = false
}

variable "kubernetes_server_vcpu" {
  description = "The number of vcpu to assign Kubernetes server"
  default     = 1
}

variable "kubernetes_server_memory" {
  description = "The number of memory to assign Kubernetes server"
  default     = "512"
}

variable "kubernetes_server_disk_size" {
  description = "The size of the disk on Kubernetes server"
  default     = "4294965097" #4gb
}

### Kubernetes worker configuration ###
variable "kubernetes_worker_name" {
  description = "The name of the Kubernetes worker node"
  default     = "k8s-worker"
}

variable "kubernetes_worker_ips" {
  description = "List of Kubernetes worker ip's"
  type        = list(string)
  default     = ["10.21.7.20", "10.21.7.21"]
}

variable "kubernetes_worker_vcpu" {
  description = "The number of vcpu to assign Kubernetes worker node"
  default     = 2
}

variable "kubernetes_worker_memory" {
  description = "The number of memory to assign"
  default     = "1024"
}

variable "kubernetes_worker_disk_size" {
  description = "The size of the disk"
  default     = "6442447645" #6gb
}

variable "registry_mirror" {
  description = "Registry Mirror address"
  default     = ""
}

variable "registry_mirror_user" {
  description = "Registry Mirror username"
  default     = ""
}

variable "registry_mirror_pass" {
  description = "Registry Mirror password"
  default     = ""
}