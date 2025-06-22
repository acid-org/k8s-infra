variable "rancher_admin_password" {
  description = "Admin password for the Rancher UI"
  type        = string
  sensitive   = true
}

variable "flux_git_repository_url" {
  description = "Git repository URL watched by Flux"
  type        = string
}

variable "flux_git_repository_branch" {
  description = "Git branch watched by Flux"
  type        = string
  default     = "main"
}

variable "flux_github_token" {
  description = "GitHub token used for Flux bootstrapping"
  type        = string
  sensitive   = true
  default     = ""
}

variable "rancher_hostname" {
  description = "Hostname used for the Rancher ingress"
  type        = string
  default     = "rancher.local"
}

variable "cluster_name" {
  description = "Name of the k3d cluster"
  type        = string
  default     = "rancher-test"
}

variable "agent_count" {
  description = "Number of k3d agent nodes"
  type        = number
  default     = 1
}

variable "storage_path" {
  description = "Host path used to persist k3s data"
  type        = string
  default     = "/var/lib/rancher/k3s"
}
