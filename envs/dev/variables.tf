variable "name" {}
variable "environment" { default = "test" }
variable "region" { default = "us-east-1" }
variable "aws_profile" { type = string }
###### Network/VPC ####################
variable "cidr_block" {
  default = "10.0.0.0/16"
}
variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "classiclink_dns_support_enabled" {
  description = "A boolean flag to enable/disable ClassicLink DNS Support for the VPC"
  type        = bool
  default     = false
}
variable "dns_hostnames_enabled" {
  default = true
}
variable "dns_support_enabled" {
  default = true
}
variable "default_security_group_deny_all" {
  default = false
}
variable "instance_tenancy" {
  default = "default"
}
variable "internet_gateway_enabled" {
  default = true
}
variable "ipv6_egress_only_internet_gateway_enabled" {
  default = false
}
variable "ipv6_enabled" {
  default = false
}
variable "application-secrets" {
  description = "A map of secrets that is passed into the application. Formatted like ENV_VAR = VALUE"
  type        = map(any)
  default = {
    ENV_VAR = "tim tom"
  }
}
variable "map_public_ip_on_launch" {
  default = true
}
variable "max_nats" {
  default = 2
}
variable "nat_elastic_ips" {
  default = []
}
variable "nat_gateway_enabled" {
  default = true
}
variable "nat_instance_enabled" {
  default = false
}
variable "nat_instance_type" {
  default = "t3.micro"
}
