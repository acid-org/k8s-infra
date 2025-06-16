variable "flux_git_repository_url" {
  description = "Git repository URL watched by Flux"
  type        = string
}

variable "flux_git_repository_branch" {
  description = "Git branch watched by Flux"
  type        = string
  default     = "main"
}
