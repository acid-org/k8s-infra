resource "k3d_cluster" "cluster" {
  name    = var.cluster_name
  servers = 1
  agents  = var.agent_count

  port {
    host_port      = 80
    container_port = 80
    node_filters   = ["loadbalancer"]
  }

  port {
    host_port      = 443
    container_port = 443
    node_filters   = ["loadbalancer"]
  }

  volume {
    source       = var.storage_path
    destination  = "/var/lib/rancher/k3s"
    node_filters = ["server:0"]
  }

  kubeconfig {
    update_default_kubeconfig = true
    switch_current_context    = true
  }
}
