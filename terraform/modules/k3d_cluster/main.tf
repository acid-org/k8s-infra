// modules/k3d_cluster/main.tf
resource "null_resource" "cluster" {
  triggers = {
    cluster_name = var.cluster_name
    agent_count  = 1
    storage_path = var.storage_path
  }

  provisioner "local-exec" {
    command = "bash ${path.module}/create_k3d_cluster.sh ${self.triggers.cluster_name} ${self.triggers.agent_count} ${self.triggers.storage_path}"
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "k3d cluster delete ${self.triggers.cluster_name}"
    interpreter = ["bash", "-c"]
  }
}
