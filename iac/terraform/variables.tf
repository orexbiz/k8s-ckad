variable "username" {
  default = "k8slab-user"
}

variable "password" {
  default = "k8slab-CKAD"
}

variable "resource_group_name" {
  type = string
  default = "ckad-labs"
}

variable "vm-a-name" {
  type = string
  default = "control-plane"
}

variable "vm-b-name" {
  type = string
  default = "workernode-1"
}

variable "vm-c-name" {
  type = string
  default = "workernode-2"
}
