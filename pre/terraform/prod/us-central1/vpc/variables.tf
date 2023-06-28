variable "vpc_cidr_block" {
  description = "The IP address range of the VPC in CIDR notation"
  type        = string
  default     = "10.6.0.0/16"
}
variable "vpc_secondary_cidr_block" {
  description = "The IP address range of the VPC's secondary address range in CIDR notation"
  type        = string
  default     = "10.7.0.0/16"
}

