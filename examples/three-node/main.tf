# Three-node RKE cluster on Harvester (3 nodes, each runs etcd + controlplane + worker)
# Requires Harvester and RKE providers to be configured (e.g. via env or root module).

module "rke" {
  source = "../.."

  cluster_namespace = var.cluster_namespace
  cluster_name      = var.cluster_name

  network_name      = var.network_name
  network_namespace = var.network_namespace
  image_name       = var.image_name
  image_namespace  = var.image_namespace

  node_count = 3

  node_cpu       = var.node_cpu
  node_memory    = var.node_memory
  node_disk_size = var.node_disk_size

  ssh_username         = var.ssh_username
  ssh_public_key       = var.ssh_public_key
  ssh_private_key_path = var.ssh_private_key_path

  kubernetes_version     = var.kubernetes_version
  server_endpoint        = var.server_endpoint # optional: LB/VIP for HA
  fetch_kubeconfig       = var.fetch_kubeconfig
  vm_tags                = var.vm_tags
  node_ips               = var.node_ips
  node_ip_prefix_length  = var.node_ip_prefix_length
  node_gateway           = var.node_gateway
  node_dns_servers       = var.node_dns_servers
}
