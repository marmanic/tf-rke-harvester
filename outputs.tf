output "node_ips" {
  description = "IP addresses of all nodes (each runs etcd + controlplane + worker)"
  value = [
    for vm in harvester_virtualmachine.node :
    vm.network_interface[0].ip_address
  ]
}

output "server_endpoint" {
  description = "Endpoint used for the cluster API (either provided or first node IP)"
  value       = local.server_endpoint
}

output "kubeconfig" {
  description = "Kubeconfig content for the RKE cluster (non-empty only when fetch_kubeconfig=true)"
  value = var.fetch_kubeconfig ? replace(
    rke_cluster.cluster.kube_config_yaml,
    "127.0.0.1",
    local.kubeconfig_server,
  ) : ""
  sensitive = true
}

output "kubeconfig_path" {
  description = "Local kubeconfig path when fetch_kubeconfig=true"
  value       = var.fetch_kubeconfig ? local.kubeconfig_fetch_path : null
}
