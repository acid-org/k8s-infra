module "k3d_cluster" {
  source       = "./modules/k3d_cluster"
  cluster_name = var.cluster_name
  agent_count  = var.agent_count
}

module "cert_manager" {
  source     = "./modules/cert_manager"
  depends_on = [module.k3d_cluster]
}

module "rancher" {
  source                 = "./modules/rancher"
  rancher_hostname       = var.rancher_hostname
  rancher_admin_password = var.rancher_admin_password
  depends_on             = [module.cert_manager]
}

module "flux" {
  source                     = "./modules/flux"
  flux_git_repository_url    = var.flux_git_repository_url
  flux_git_repository_branch = var.flux_git_repository_branch
  flux_github_token          = var.flux_github_token
  depends_on                 = [module.rancher]
}
