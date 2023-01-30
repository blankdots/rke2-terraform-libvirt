### Common configuration ###

variable "os_image" {
  description = "Define the source to the os image used by Kubernetes"
  default     = "https://cloud-images.ubuntu.com/releases/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img"
  type        = string
}

variable "kubernetes_pool_path" {
  description = "Define the path to libvirt pool"
  default     = "/tmp/terraform-provider-libvirt-pool-kubernetes"
  type        = string
}

variable "kubernetes_node_ssh_username" {
  description = "SSH username on vm"
  default     = "kubernetes"
  type        = string
}

variable "kubernetes_node_public_key_path" {
  description = "Path to public key, must be absolute"
  default     = "/home/user/keys/your_public_key"
  type        = string
}

variable "kubernetes_join_token" {
  description = "Token used to join cluster"
  default     = "secrettoken"
  sensitive   = true
  type        = string
}

### Kubernetes server configuration ###
variable "kubernetes_server_name" {
  description = "The name of the Kubernetes server"
  default     = "k8s-server"
  type        = string
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
  type        = number
}

variable "kubernetes_server_memory" {
  description = "The number of memory to assign Kubernetes server"
  default     = "512"
  type        = string
}

variable "kubernetes_server_disk_size" {
  description = "The size of the disk on Kubernetes server"
  default     = "4294965097" #4gb
  type        = string
}

### Kubernetes worker configuration ###
variable "kubernetes_worker_name" {
  description = "The name of the Kubernetes worker node"
  default     = "k8s-worker"
  type        = string
}

variable "kubernetes_worker_ips" {
  description = "List of Kubernetes worker ip's"
  type        = list(string)
  default     = ["10.21.7.20", "10.21.7.21"]
}

variable "kubernetes_worker_vcpu" {
  description = "The number of vcpu to assign Kubernetes worker node"
  default     = 2
  type        = number
}

variable "kubernetes_worker_memory" {
  description = "The number of memory to assign"
  default     = "1024"
  type        = string
}

variable "kubernetes_worker_disk_size" {
  description = "The size of the disk"
  default     = "6442447645" #6gb
  type        = string
}

variable "registry_mirror" {
  description = "Registry Mirror address"
  default     = ""
  type        = string
}

variable "registry_mirror_user" {
  description = "Registry Mirror username"
  default     = ""
  type        = string
}

variable "registry_mirror_pass" {
  description = "Registry Mirror password"
  default     = ""
  type        = string
}
