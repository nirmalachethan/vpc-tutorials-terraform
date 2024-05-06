# VPC with one subnet, one VSI and a floating IP
provider "ibm" {
  region           = var.ibm_region
}

resource "ibm_is_vpc" "vpc" {
  name = var.basename
}

# vsi1 access 
resource "ibm_is_security_group" "sg1" {
  name = "${var.basename}-sg1"
  vpc  = ibm_is_vpc.vpc.id
}

resource "ibm_is_subnet" "subnet1" {
  name                     = "${var.basename}-subnet1"
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = var.ibm_zones[0]
  total_ipv4_address_count = 256
}

data "ibm_is_ssh_key" "ssh_key" {
  name       = "nir-sshkey"
   type       = "rsa"
   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCfXbvbgwWQztwtlK/DGvuXft80hyf/7Sj+PuTyvcg8xc4e+ASVpAzWell4KJuZ1sSKiud5/WaPuRpTcxpQn2E/ARln4IKRFt1YhjBo+Y33LSyPin9TiyT2PEUQzTH5guxYiDVR674A9IjEdnsr4ror1oAdHuQcGc3v9VbKvoBmAQ6y76J+Gur9TVzm2ygRVwlzvlXwaOKC7TzspxcnVOQgY12wPOoplp8JSF7o7km1sLGRmrFmIQdAzLLJ2A8ToyUhQIjVr2fcSA511GKdgrjX1qbN7s/pY0e9pLzAr4qMXsEdbVxQUUfp3oe33SFDvZORH99eb9ozPIlgyLbB2TdujOL2knT+iAgHOrzW+Gn9PxEuxtm1K/C/HkYHILlzwPRy/WCdBKWAEo/RPES2o3A1y+TbW6x0K+eIi0muswfloYyvxxVOip9AGNH56Y4fj+/6jcM4uzf3njlVP087WxRhT3o0Rf5VQzwdBlqhDUBI8M6b3bnRQ+hZP4M0L7C3cVM= nirmala.marilingaiah@nirmalamarilingaiahs-MacBook-Pro.local"
}

data "ibm_is_image" "ubuntu" {
  name = var.ubuntu1804
}

resource "ibm_is_instance" "vsi1" {
  name    = "${var.basename}-vsi1"
  vpc     = ibm_is_vpc.vpc.id
  zone    = var.ibm_zones[0]
  keys    = [data.ibm_is_ssh_key.ssh_key.id]
  image   = data.ibm_is_image.ubuntu.id
  profile = var.profile

  primary_network_interface {
    subnet = ibm_is_subnet.subnet1.id
    security_groups = local.ibm_vsi1_security_groups
  }

  user_data = local.ibm_vsi1_user_data
}

resource "ibm_is_floating_ip" "vsi1" {
  name   = "${var.basename}-vsi1"
  target = ibm_is_instance.vsi1.primary_network_interface[0].id
}

output "vpc_id" {
  value = ibm_is_vpc.vpc.id
}

output "ibm1_public_ip" {
  value = ibm_is_floating_ip.vsi1.address
}

output "ibm1_private_ip" {
  value = ibm_is_instance.vsi1.primary_network_interface[0].primary_ipv4_address
}
