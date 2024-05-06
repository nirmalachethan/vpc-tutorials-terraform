# Shared
variable "basename" {
  description = "Name for the VPCs to create and prefix to use for all other resources."
  default     = "perfimagevpc"
}


variable "ssh_key_name" {
}

variable "ibm_region" {
  default = "us-south"
}

variable "ibm_zones" {
  default = [
    "us-south-1",
    "us-south-2",
    "us-south-3",
  ]
}

variable "ubuntu1804" {
  default = "perftestimage"
}

variable "profile" {
  default = "cx2-2x4"
}

