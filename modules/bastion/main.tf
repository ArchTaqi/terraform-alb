module "bastion" {
  source  = "cloudposse/ec2-bastion-server/aws"
  version = "0.30.0"

  name                          = join("", [var.name, "-", var.environment, "-", "bastion-host"])
  ami                           = var.ami_id
  instance_type                 = var.instance_type
  key_name                      = var.key_pair_name
  ssh_user                      = var.bastion_ssh_user
  vpc_id                        = var.vpc_id
  subnets                       = var.subnet_ids
  security_groups               = var.security_group_ids
  associate_public_ip_address   = var.public_ip_address
  root_block_device_volume_size = var.root_block_device_volume_size
  security_group_enabled        = var.security_group_enabled
  user_data_base64              = var.user_data_base64

  tags = {
    Name        = "${var.name}-${var.environment}-bastion-host"
    Environment = var.environment
    Terraform   = "Yes"
  }
}
