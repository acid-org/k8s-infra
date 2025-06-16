variable "flux_git_repository_url" {
  type = string
}

variable "flux_git_repository_branch" {
  type = string
}

variable "flux_github_token" {
  type      = string
  sensitive = true
}
