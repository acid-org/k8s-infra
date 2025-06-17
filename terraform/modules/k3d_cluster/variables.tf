variable "cluster_name" {
  type    = string
  default = "local-k3s-cluster"
}

variable "agent_count" {
  type    = number
  default = 2
}

variable "storage_path" {
  type        = string
  description = "Host path used to persist k3s data"
  default     = "/media/acid/windows/k3s"
}
