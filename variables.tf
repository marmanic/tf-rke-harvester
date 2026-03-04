variable "cluster_namespace" {
  description = "Harvester namespace/project to create VMs in"
  type        = string
}

variable "network_name" {
  description = "Harvester network to attach to VMs"
  type        = string
}

variable "network_namespace" {
  description = "Harvester namespace where the network exists (often harvester-public)"
  type        = string
  default     = "harvester-public"
}

variable "image_name" {
  description = "Harvester image name to use for VMs"
  type        = string
}

variable "image_namespace" {
  description = "Harvester namespace where the image exists (often harvester-public)"
  type        = string
  default     = "harvester-public"
}

variable "cluster_name" {
  description = "Logical name for the RKE cluster"
  type        = string
}

variable "node_count" {
  description = "Number of all-in-one nodes (each runs etcd + controlplane + worker)"
  type        = number
  default     = 1

  validation {
    condition     = var.node_count >= 1
    error_message = "node_count must be at least 1."
  }
}

variable "vm_tags" {
  description = "Additional Harvester VM tags (translated to labels)"
  type        = map(string)
  default     = {}
}

variable "wait_for_lease" {
  description = "Wait for VM NIC to obtain an IP lease (requires qemu-guest-agent for non-management networks)"
  type        = bool
  default     = false
}

variable "node_cpu" {
  description = "vCPU count per node"
  type        = number
  default     = 2
}

variable "node_memory" {
  description = "Memory per node, e.g. 4Gi"
  type        = string
  default     = "4Gi"
}

variable "node_disk_size" {
  description = "Root disk size per node, e.g. 40Gi"
  type        = string
  default     = "40Gi"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the RKE cluster (e.g. v1.28.2). Omit to use provider default."
  type        = string
  default     = ""
}

variable "server_endpoint" {
  description = "Optional stable endpoint (DNS/LB/VIP) for the API. If empty, the first node's IP is used."
  type        = string
  default     = ""
}

variable "ssh_username" {
  description = "SSH username to create on nodes"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for access to nodes"
  type        = string
}

variable "ssh_agent_auth" {
  description = "Enable SSH agent authentication"
  type        = bool
  default     = true
}

variable "ssh_private_key_path" {
  description = "Path to private key for SSH. Required by the RKE provider to connect to nodes and install Kubernetes."
  type        = string

  validation {
    condition     = var.ssh_private_key_path != ""
    error_message = "ssh_private_key_path is required for the RKE provider to connect to nodes."
  }
}

variable "fetch_kubeconfig" {
  description = "Whether to write the RKE cluster kubeconfig to a local file (from rke_cluster.kube_config_yaml)"
  type        = bool
  default     = false
}

variable "kubeconfig_output_path" {
  description = "Local path where the kubeconfig should be written when fetch_kubeconfig=true"
  type        = string
  default     = ""
}

variable "kubeconfig_server" {
  description = "Optional server host/IP to replace 127.0.0.1 in the written kubeconfig. Defaults to server_endpoint."
  type        = string
  default     = ""
}

variable "cloud_init_additional_userdata" {
  description = "Extra cloud-init YAML appended to the generated user-data"
  type        = string
  default     = ""
}

# ------------------------------------------------------------------------------
# Static IP (optional). When node_ips is set, each node gets that IP via cloud-init.
# ------------------------------------------------------------------------------

variable "node_ips" {
  description = "Optional list of static IPs, one per node (index matches node index). When empty, nodes use Harvester network IPAM (e.g. DHCP)."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.node_ips) == 0 || length(var.node_ips) == var.node_count
    error_message = "When set, node_ips must have exactly node_count entries (one IP per node)."
  }
}

variable "node_ip_prefix_length" {
  description = "Prefix length for node static IPs (e.g. 24 for /24). Used only when node_ips is set."
  type        = number
  default     = 24
}

variable "node_gateway" {
  description = "Default gateway for node static IPs. Required when node_ips is set."
  type        = string
  default     = ""
}

variable "node_dns_servers" {
  description = "Optional DNS servers for node static IPs. Used only when node_ips is set."
  type        = list(string)
  default     = []
}
