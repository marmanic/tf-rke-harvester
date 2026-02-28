# Single-node RKE cluster on Harvester

Creates one Harvester VM and installs a single-node RKE (RKE1) Kubernetes cluster on it. The node runs all three roles: etcd, controlplane, and worker.

## Prerequisites

- Harvester cluster with a network and a VM image (e.g. Ubuntu 22.04)
- SSH key pair for node access (public key in cloud-init, private key for the RKE provider)
- Terraform with `harvester` and `rancher/rke` providers configured

## Usage

1. Configure the Harvester provider (e.g. in a `provider.tf` or via environment):

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
