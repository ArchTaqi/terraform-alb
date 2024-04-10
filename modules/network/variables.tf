variable "name" {
  type        = string
  description = "Solution name, which could be your organization name, e.g. 'eg' or 'cp'"
}

variable "environment" {
  type        = string
  description = "Stage, e.g. 'prod', 'staging', 'dev', or 'test'"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC."
}

variable "availability_zones" {
  description = "a comma-separated list of availability zones, where subnets will be created"
}

variable "dns_hostnames_enabled" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "dns_support_enabled" {
  description = "A boolean flag to enable/disable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "instance_tenancy" {
  type        = string
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "internet_gateway_enabled" {
  type        = bool
  description = ""
  default     = true
}

variable "ipv6_egress_only_internet_gateway_enabled" {
  type        = string
  description = "A boolean flag to enable/disable IPv6 Egress-Only Internet Gateway creation"
  default     = false
}

variable "ipv6_enabled" {
  description = "Whether to assign generated ipv6 cidr block to the VPC"
  type        = bool
  default     = false
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Instances launched into a public subnet should be assigned a public IP address"
  default     = true
}
variable "max_nats" {
  type    = number
  default = 2
}
variable "nat_elastic_ips" {
  type        = list(string)
  description = "Existing Elastic IPs to attach to the NAT Gateway(s) or Instance(s) instead of creating new ones."
  default     = []
}
variable "nat_gateway_enabled" {
  type        = bool
  description = "Flag to enable/disable NAT Gateways to allow servers in the private subnets to access the Internet"
  default     = true
}
variable "nat_instance_enabled" {
  type        = bool
  description = "Flag to enable/disable NAT Instances to allow servers in the private subnets to access the Internet"
  default     = false
}
variable "nat_instance_type" {
  type        = string
  description = "NAT Instance type"
  default     = "t3.micro"
}
variable "default_security_group_deny_all" {
  type        = bool
  description = <<EOT
    When true, manage the default security group and remove all rules, disabling all ingress and egress.
    When false, do not manage the default security group, allowing it to be managed by another component
    EOT
  default     = false
}
variable "vpc_logs_retention_in_days" {
  default = 3
}
