resource "k3d_cluster" "cluster" {
  name          = var.cluster_name
  servers_count = 1
  agents_count  = var.agent_count

  ports {
    host_port      = 80
    container_port = 80
    node_filters   = ["loadbalancer"]
  }

  ports {
    host_port      = 443
    container_port = 443
    node_filters   = ["loadbalancer"]
  }

  volumes {
    source       = var.storage_path
    destination  = "/var/lib/rancher/k3s"
    node_filters = ["server:0"]
  }

  kube_config {
    update_default = true
    switch_context = true
  }
}
