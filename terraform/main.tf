# Create a local k3d cluster using local-exec
# This requires k3d to be installed on the machine running Terraform
resource "null_resource" "k3d_cluster" {
  provisioner "local-exec" {
    command     = "k3d cluster create rancher-test --agents 2"
    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "k3d cluster delete rancher-test"
    interpreter = ["bash", "-c"]
  }
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = true
  }

  depends_on = [null_resource.k3d_cluster]
}

resource "helm_release" "rancher" {
  name             = "rancher"
  repository       = "https://releases.rancher.com/server-charts/stable"
  chart            = "rancher"
  namespace        = "cattle-system"
  create_namespace = true

  set {
    name  = "hostname"
    value = var.rancher_hostname
  }

  set {
    name  = "replicas"
    value = 1
  }

  set_sensitive {
    name  = "bootstrapPassword"
    value = var.rancher_admin_password
    type  = "string"
  }

  depends_on = [helm_release.cert_manager]
}

# Port-forward the Rancher service locally
resource "null_resource" "rancher_port_forward" {
  depends_on = [helm_release.rancher]

  provisioner "local-exec" {
    command     = "nohup kubectl -n cattle-system port-forward svc/rancher 8443:443 >/tmp/rancher-port-forward.log 2>&1 & echo $! > /tmp/rancher-port-forward.pid"
    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "if [ -f /tmp/rancher-port-forward.pid ]; then kill $(cat /tmp/rancher-port-forward.pid); rm /tmp/rancher-port-forward.pid; fi"
    interpreter = ["bash", "-c"]
  }
}

# Install FluxCD once Rancher is ready
resource "null_resource" "flux_install" {
  depends_on = [helm_release.rancher]

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

