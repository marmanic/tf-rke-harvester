terraform {
  required_providers {
    harvester = {
      source = "harvester/harvester"
    }
    rke = {
      source = "rancher/rke"
    }
    random = {
      source = "hashicorp/random"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

data "harvester_network" "vm" {
  name      = var.network_name
  namespace = var.network_namespace
}

data "harvester_image" "os" {
  name      = var.image_name
  namespace = var.image_namespace
}

locals {
  # All nodes run etcd + controlplane + worker (all-in-one)
  rke_nodes = [for vm in harvester_virtualmachine.node : {
    address = vm.network_interface[0].ip_address
    role    = ["controlplane", "etcd", "worker"]
  }]
  server_endpoint       = var.server_endpoint != "" ? var.server_endpoint : harvester_virtualmachine.node[0].network_interface[0].ip_address
  kubeconfig_fetch_path  = var.kubeconfig_output_path != "" ? var.kubeconfig_output_path : "${path.root}/kubeconfig_${var.cluster_name}.yaml"
  kubeconfig_server     = var.kubeconfig_server != "" ? var.kubeconfig_server : local.server_endpoint
}

# ------------------------------------------------------------------------------
# Harvester VMs: one resource, N nodes. Each node runs etcd + controlplane + worker.
# Cloud-init installs Docker and SSH; RKE provider installs Kubernetes.
# ------------------------------------------------------------------------------

resource "harvester_virtualmachine" "node" {
  count = var.node_count

  name      = "${var.cluster_name}-node-${count.index}"
  namespace = var.cluster_namespace

  cpu    = var.node_cpu
  memory = var.node_memory

  tags = merge(
    { "ssh-user" = var.ssh_username },
    var.vm_tags,
  )

  network_interface {
    name           = "nic-1"
    network_name   = data.harvester_network.vm.id
    wait_for_lease = var.wait_for_lease
  }

  disk {
    name        = "rootdisk"
    type        = "disk"
    size        = var.node_disk_size
    bus         = "virtio"
    boot_order  = 1
    image       = data.harvester_image.os.id
    auto_delete = true
  }

  cloudinit {
    user_data = templatefile("${path.module}/templates/cloud-init-node.yaml.tftpl", {
      ssh_username        = var.ssh_username
      ssh_public_key      = var.ssh_public_key
      additional_userdata = var.cloud_init_additional_userdata
    })
  }
}

# ------------------------------------------------------------------------------
# RKE cluster: provider installs Kubernetes on the Harvester nodes via SSH.
# Every node has all three roles: controlplane, etcd, worker.
# ------------------------------------------------------------------------------

resource "rke_cluster" "cluster" {
  cluster_name = var.cluster_name

  dynamic "nodes" {
    for_each = local.rke_nodes
    content {
      address = nodes.value.address
      user    = var.ssh_username
      role    = nodes.value.role
      ssh_key = file(var.ssh_private_key_path)
    }
  }

  kubernetes_version = var.kubernetes_version != "" ? var.kubernetes_version : null
  enable_cri_dockerd = true

  ssh_agent_auth = var.ssh_agent_auth
  
  depends_on = [harvester_virtualmachine.node]
}

# Write kubeconfig to local file when requested
resource "local_file" "kubeconfig" {
  count = var.fetch_kubeconfig ? 1 : 0

  content = replace(
    rke_cluster.cluster.kube_config_yaml,
    "127.0.0.1",
    local.kubeconfig_server,
  )
  filename = local.kubeconfig_fetch_path
}
