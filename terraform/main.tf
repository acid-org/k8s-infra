# Install FluxCD after Rancher is up

resource "null_resource" "flux_install" {
  # Replace this trigger with an appropriate dependency on Rancher installation
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "flux install --namespace flux-system --url=${var.flux_git_repository_url} --branch=${var.flux_git_repository_branch}"
  }
}
