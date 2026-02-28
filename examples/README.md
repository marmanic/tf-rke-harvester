# Examples

Example configurations for the Harvester RKE cluster module.

| Example | Description |
|---------|-------------|
| [single-node](./single-node/) | One Harvester VM running a single-node RKE cluster (etcd + controlplane + worker on one node). |
| [three-node](./three-node/) | Three Harvester VMs running an RKE cluster with each node having all roles (small HA setup). |

Each example is self-contained: copy the directory (or run from it), set your variables (e.g. via `terraform.tfvars` from the `.example` file), configure the Harvester (and optionally RKE) provider, then `terraform init`, `plan`, and `apply`.
