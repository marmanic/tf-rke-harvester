output "node_ips" {
  description = "IP addresses of cluster nodes"
  value       = module.rke.node_ips
}

output "server_endpoint" {
  description = "Cluster API endpoint"
  value       = module.rke.server_endpoint
}

output "kubeconfig_path" {
  description = "Path to kubeconfig file (when fetch_kubeconfig=true)"
  value       = module.rke.kubeconfig_path
}
