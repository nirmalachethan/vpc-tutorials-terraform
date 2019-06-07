data "ibm_is_vpc" "vpc" {
  name = "${var.vpc_name}"
}

data "ibm_is_image" "ds_image" {
  name = "centos-7.x-amd64"
}

data "ibm_is_ssh_key" "ds_key" {
  name = "${var.ssh_keyname}"
}

resource "ibm_is_vpc_address_prefix" "vpc_address_prefix" {
  name = "${var.basename}-prefix"
  zone = "us-south-1"
  vpc  = "${data.ibm_is_vpc.vpc.id}"
  cidr = "192.168.0.0/16"
}

resource "ibm_is_subnet" "subnet" {
  name            = "${var.basename}-subnet"
  vpc             = "${data.ibm_is_vpc.vpc.id}"
  zone            = "${var.subnet_zone}"
  ipv4_cidr_block = "${ibm_is_vpc_address_prefix.vpc_address_prefix.cidr}"
}

resource "ibm_is_instance" "instance" {
  name    = "${var.basename}-instance"
  vpc     = "${data.ibm_is_vpc.vpc.id}"
  zone    = "${var.subnet_zone}"
  profile = "cc1-2x4"
  image   = "${data.ibm_is_image.ds_image.id}"
  keys    = ["${data.ibm_is_ssh_key.ds_key.id}"]

  primary_network_interface = {
    port_speed = "100"
    subnet     = "${ibm_is_subnet.subnet.id}"
  }
}