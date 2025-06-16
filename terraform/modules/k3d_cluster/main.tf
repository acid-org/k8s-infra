resource "null_resource" "cluster" {
  triggers = {
    cluster_name = var.cluster_name
    agent_count  = var.agent_count
  }

  provisioner "local-exec" {
    command     = "k3d cluster create ${self.triggers.cluster_name} --agents ${self.triggers.agent_count} -p \"80:80@loadbalancer\" -p \"443:443@loadbalancer\""
    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "k3d cluster delete ${self.triggers.cluster_name}"
    interpreter = ["bash", "-c"]
  }
}
