# Terraform setup
terraform {
  required_version = ">= 1.2.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3"
    }
  }
}

# Provider
provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

#####################################
# Local
#####################################
locals {
  logs_retention_in_days = 3
  bastion_ssh_user       = "ubuntu"
}

#####################################
# VPC & Subnets
#####################################
module "network" {
  source = "../../modules/network"

  name        = var.name
  environment = var.environment

  # VPC vars
  cidr_block                                = var.cidr_block
  default_security_group_deny_all           = var.default_security_group_deny_all
  dns_hostnames_enabled                     = var.dns_hostnames_enabled
  dns_support_enabled                       = var.dns_support_enabled
  instance_tenancy                          = var.instance_tenancy
  internet_gateway_enabled                  = var.internet_gateway_enabled
  ipv6_egress_only_internet_gateway_enabled = var.ipv6_egress_only_internet_gateway_enabled
  ipv6_enabled                              = var.ipv6_enabled
  vpc_logs_retention_in_days                = local.logs_retention_in_days

  # Subnets vars
  availability_zones      = var.availability_zones
  map_public_ip_on_launch = var.map_public_ip_on_launch
  max_nats                = var.max_nats
  nat_elastic_ips         = var.nat_elastic_ips
  nat_gateway_enabled     = var.nat_gateway_enabled
  nat_instance_enabled    = var.nat_instance_enabled
  nat_instance_type       = var.nat_instance_type
}
