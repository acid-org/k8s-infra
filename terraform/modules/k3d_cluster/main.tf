// modules/k3d_cluster/main.tf
resource "null_resource" "cluster" {
  triggers = {
    cluster_name = var.cluster_name
    agent_count  = var.agent_count
    storage_path = var.storage_path
  }

  provisioner "local-exec" {
    command = <<-EOT
      set -eux

      # ensure host storage dir exists and is empty
      mkdir -p "${self.triggers.storage_path}"
      rm -rf "${self.triggers.storage_path}"/*

      # delete any existing k3d cluster
      if k3d cluster list --no-headers | awk '{print $1}' | grep -x "${self.triggers.cluster_name}"; then
        k3d cluster delete "${self.triggers.cluster_name}"
      fi

      # create new cluster: 1 control-plane + N workers, with persistent storage
      k3d cluster create "${self.triggers.cluster_name}" \
        --servers 1 \
        --agents "${self.triggers.agent_count}" \
        -p "80:80@loadbalancer" \
        -p "443:443@loadbalancer" \
        --volume "${self.triggers.storage_path}:/var/lib/rancher/k3s@server:0" \
        --volume "${self.triggers.storage_path}:/var/lib/rancher/k3s@agent:*" \
        --timeout 10m \
        --wait
    EOT
    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "k3d cluster delete ${self.triggers.cluster_name}"
    interpreter = ["bash", "-c"]
  }
}
