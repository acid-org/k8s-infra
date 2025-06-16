variable "cluster_name" {
  type = string
}

variable "agent_count" {
  type = number
}

variable "storage_path" {
  type        = string
  description = "Host path used to persist k3s data"
}
