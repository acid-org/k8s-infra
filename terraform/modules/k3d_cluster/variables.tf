// modules/k3d_cluster/variables.tf
variable "cluster_name" {
  type        = string
  description = "Name for the k3d cluster"
  default     = "local-k3s-cluster"
}

variable "agent_count" {
  type        = number
  description = "How many worker (agent) nodes to spin up"
  default     = 1
}

variable "storage_path" {
  type        = string
  description = "Host path used to persist all k3s data"
  default     = "/media/acid/windows/k3s"
}
