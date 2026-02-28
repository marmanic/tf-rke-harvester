variable "cluster_namespace" {
  description = "Harvester namespace/project to create VMs in"
  type        = string
}

variable "cluster_name" {
  description = "Logical name for the RKE cluster"
  type        = string
}

variable "network_name" {
  description = "Harvester network to attach to VMs"
  type        = string
}

variable "network_namespace" {
  description = "Harvester namespace where the network exists"
  type        = string
  default     = "harvester-public"
}

variable "image_name" {
  description = "Harvester image name (e.g. Ubuntu 22.04)"
  type        = string
}

variable "image_namespace" {
  description = "Harvester namespace where the image exists"
  type        = string
  default     = "harvester-public"
}

variable "node_cpu" {
  description = "vCPU count per node"
  type        = number
  default     = 2
}

variable "node_memory" {
  description = "Memory per node"
  type        = string
  default     = "4Gi"
}

variable "node_disk_size" {
  description = "Root disk size per node"
  type        = string
  default     = "40Gi"
}

variable "ssh_username" {
  description = "SSH username to create on nodes"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for access to nodes"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key (used by RKE provider to connect to nodes)"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for RKE (omit for provider default)"
  type        = string
  default     = ""
}

variable "server_endpoint" {
  description = "Optional stable API endpoint (LB/VIP/DNS) for HA; if empty, first node IP is used"
  type        = string
  default     = ""
}

variable "fetch_kubeconfig" {
  description = "Write kubeconfig to a local file"
  type        = bool
  default     = true
}

variable "vm_tags" {
  description = "Additional Harvester VM tags"
  type        = map(string)
  default     = {}
}
