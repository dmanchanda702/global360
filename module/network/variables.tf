variable "name_prefix" {
  description = "Naming prefix"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "azs" {
  description = "Availability Zones to use"
  type        = list(string)
}

variable "ssh_ingress_cidr" {
  description = "CIDR allowed for SSH"
  type        = string
}

variable "enable_ssh" {
  description = "Whether to allow SSH ingress"
  type        = bool
}

variable "tags" {
  description = "Tags map"
  type        = map(string)
  default     = {}
}
