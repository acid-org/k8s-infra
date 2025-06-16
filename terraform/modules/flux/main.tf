resource "null_resource" "flux_install" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "mkdir -p /tmp/fluxcd && flux bootstrap git --url=${var.flux_git_repository_url} --branch=${var.flux_git_repository_branch} --path=. --token-auth --username=git"
    environment = {
      TMPDIR       = "/tmp/fluxcd"
      GIT_PASSWORD = var.flux_github_token
    }
  }
}
