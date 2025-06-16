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
}
