# Single-node RKE cluster on Harvester

Creates one Harvester VM and installs a single-node RKE (RKE1) Kubernetes cluster on it. The node runs all three roles: etcd, controlplane, and worker.

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

3. Apply:

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. Use the cluster:

   ```bash
   export KUBECONFIG=$(terraform output -raw kubeconfig_path)
   kubectl get nodes
   ```

### Optional: static IP

To give the single node a fixed IP instead of DHCP, set `node_ips`, `node_ip_prefix_length`, and `node_gateway` in `terraform.tfvars` (see [module README](../../README.md#static-ip-addresses)). Example:

```hcl
node_ips              = ["10.0.0.11"]
node_ip_prefix_length = 24
node_gateway          = "10.0.0.1"
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
| fetch_kubeconfig | Write kubeconfig to file | true |
| node_ips | Optional list of static IPs (one per node) | [] |
| node_ip_prefix_length | Prefix length for static IPs (e.g. 24) | 24 |
| node_gateway | Default gateway (required when node_ips set) | "" |
| node_dns_servers | Optional DNS servers for static IPs | [] |
