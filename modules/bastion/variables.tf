variable "name" {}
variable "environment" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_pair_name" {}
variable "bastion_ssh_user" {}
variable "vpc_id" {}
variable "subnet_ids" {}
variable "security_group_ids" {}
variable "public_ip_address" {}
variable "security_group_enabled" { default = false }
variable "root_block_device_volume_size" {
  type    = number
  default = 8
}
variable "user_data_base64" {
  description = "User data content"
}
