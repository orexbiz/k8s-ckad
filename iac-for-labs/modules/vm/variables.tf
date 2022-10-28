variable "resource_gr" {
  default = "rg"
  type    = string
}

variable "location" {
  default = "eastus"
  type    = string
}

variable "name" {
  default = "k8s-vm"
  type    = string
}

variable "sub_net" {
  default = {}
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}
