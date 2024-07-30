
# Shared

#---------------------------------------------------------
## DEFINE VPC
#---------------------------------------------------------

variable "basename" {
  description = "Name for the VPCs to create and prefix to use for all other resources."
  default     = "perf_vpc_01"
}

variable "vpc-count" {
  default = 1
}

variable "ssh_key_name" {
  default = "nirmala-ssh"
}

variable "ibm_region" {
  default = "us-south"
}

variable "ibm_zones" {
  default = [
    "us-south-1",
  ]
}

variable "ubuntu1804" {
  default = "test1"
}

variable "profile" {
  default = "cx2-2x4"
}

