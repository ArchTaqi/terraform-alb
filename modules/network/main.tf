#############################################################
# AWS VPC
#############################################################
module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "2.0.0"

  name  = "${var.name}-${var.environment}-vpc"
  stage = var.environment

  ipv4_primary_cidr_block                   = var.cidr_block
  default_security_group_deny_all           = var.default_security_group_deny_all
  dns_hostnames_enabled                     = var.dns_hostnames_enabled
  dns_support_enabled                       = var.dns_support_enabled
  instance_tenancy                          = var.instance_tenancy
  internet_gateway_enabled                  = var.internet_gateway_enabled
  ipv6_egress_only_internet_gateway_enabled = var.ipv6_egress_only_internet_gateway_enabled
  assign_generated_ipv6_cidr_block          = var.ipv6_enabled

  tags = {
    Name        = "${var.name}-${var.environment}-vpc"
    Environment = var.environment
    Terraform   = "Yes"
  }
}

#############################################################
# Subnets Defenitions
#############################################################
module "subnets" {
  source     = "cloudposse/dynamic-subnets/aws"
  version    = "2.0.4"
  depends_on = [module.vpc]

  name  = "${var.name}-${var.environment}-subnet"
  stage = var.environment

  vpc_id                  = module.vpc.vpc_id
  availability_zones      = var.availability_zones
  ipv4_cidr_block         = [module.vpc.vpc_cidr_block]
  igw_id                  = [module.vpc.igw_id]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  max_nats                = var.max_nats
  nat_elastic_ips         = var.nat_elastic_ips
  nat_gateway_enabled     = var.nat_gateway_enabled
  nat_instance_enabled    = var.nat_instance_enabled
  nat_instance_type       = var.nat_instance_type
  tags = {
    Name        = "${var.name}-${var.environment}-subnet"
    Environment = var.environment
    Terraform   = "Yes"
  }
}
resource "aws_flow_log" "main" {
  depends_on = [module.vpc, module.subnets]

  iam_role_arn    = aws_iam_role.vpc-flow-logs-role.arn
  log_destination = aws_cloudwatch_log_group.main.arn
  traffic_type    = "ALL"
  vpc_id          = module.vpc.vpc_id
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "${var.name}-${var.environment}-cloudwatch-log-group"
  retention_in_days = var.vpc_logs_retention_in_days
}

resource "aws_iam_role" "vpc-flow-logs-role" {
  name = "${var.name}-${var.environment}-vpc-flow-logs-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "vpc-flow-logs-policy" {
  name = "${var.name}-${var.environment}-vpc-flow-logs-policy"
  role = aws_iam_role.vpc-flow-logs-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
