variable "kube_config_path" {
  description = "Path to the Kubernetes config file"
  type        = string
  default     = "~/.kube/config"
}

variable "kube_config_context" {
  description = "Kubernetes context to use"
  type        = string
  default     = "minikube"
}

variable "postgres_db" {
  description = "Name of the PostgreSQL database"
  type        = string
  default     = "greeting_rust"
}

variable "postgres_user" {
  description = "PostgreSQL username"
  type        = string
  default     = "greeting_rust"
}

variable "postgres_password" {
  description = "Base64-encoded PostgreSQL password"
  type        = string
  default     = "Z3JlZXRpbmdfcnVzdAo="
}


