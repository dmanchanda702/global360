variable "name_prefix" {
  description = "Naming prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group ID for ALB"
  type        = string
}

variable "tags" {
  description = "Tags map"
  type        = map(string)
  default     = {}
}
