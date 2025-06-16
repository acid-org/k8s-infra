resource "null_resource" "cluster" {
  triggers = {
    cluster_name = var.cluster_name
    agent_count  = var.agent_count
    storage_path = var.storage_path
  }

  provisioner "local-exec" {
    command     = "k3d cluster create ${self.triggers.cluster_name} --agents ${self.triggers.agent_count} -p \"80:80@loadbalancer\" -p \"443:443@loadbalancer\" --volume ${self.triggers.storage_path}:/var/lib/rancher/k3s@server:0"
    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "k3d cluster delete ${self.triggers.cluster_name}"
    interpreter = ["bash", "-c"]
  }
}
