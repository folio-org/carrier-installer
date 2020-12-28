variable "access_key" {}
variable "secret_key" {}
variable "vm_type" {}
variable "ami" {}
variable "key_name" {}
variable "disk_size" {}


variable "region" {
     default = "us-east-1"
}
variable "ingressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
