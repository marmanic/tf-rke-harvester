# Three-node RKE cluster on Harvester

Creates three Harvester VMs and installs an RKE (RKE1) Kubernetes cluster with each node running all three roles: etcd, controlplane, and worker. This gives you a small HA-capable cluster (etcd and control plane replicated across three nodes).

## Prerequisites

- Harvester cluster with a network and a VM image (e.g. Ubuntu 22.04)
- SSH key pair for node access (public key in cloud-init, private key for the RKE provider)
- Terraform with `harvester` and `rancher/rke` providers configured

## Usage

1. Configure the Harvester provider in this example’s `providers.tf` (or via environment):

   ```hcl
   provider "harvester" {
     kubeconfig = "~/.kube/harvester.yaml"  # or your Harvester kubeconfig path
   }
   ```

2. Copy `terraform.tfvars.example` to `terraform.tfvars` and set your values:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. (Optional) For HA access, set `server_endpoint` to a load balancer or VIP in front of the three node IPs (e.g. TCP port 6443). Otherwise the kubeconfig will use the first node’s IP.

4. (Optional) To use static IPs instead of DHCP, set `node_ips`, `node_ip_prefix_length`, and `node_gateway` (see [module README](../../README.md#static-ip-addresses)). Example: `node_ips = ["10.0.0.11", "10.0.0.12", "10.0.0.13"]`, `node_ip_prefix_length = 24`, `node_gateway = "10.0.0.1"`.

5. Apply:

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

6. Use the cluster:

   ```bash
   export KUBECONFIG=$(terraform output -raw kubeconfig_path)
   kubectl get nodes
   ```

## Inputs

| Name | Description | Default |
|------|-------------|--------|
| cluster_namespace | Harvester namespace for VMs | (required) |
| cluster_name | Name of the RKE cluster | (required) |
| network_name | Harvester network name | (required) |
| image_name | Harvester image name | (required) |
| ssh_username | SSH user on nodes | (required) |
| ssh_public_key | SSH public key content | (required) |
| ssh_private_key_path | Path to SSH private key | (required) |
| node_cpu | vCPUs per node | 2 |
| node_memory | Memory per node | 4Gi |
| node_disk_size | Root disk size | 40Gi |
| server_endpoint | Optional LB/VIP for API (HA) | "" |
| fetch_kubeconfig | Write kubeconfig to file | true |
| node_ips | Optional list of static IPs (one per node) | [] |
| node_ip_prefix_length | Prefix length for static IPs (e.g. 24) | 24 |
| node_gateway | Default gateway (required when node_ips set) | "" |
| node_dns_servers | Optional DNS servers for static IPs | [] |
