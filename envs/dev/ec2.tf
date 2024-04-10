module "bastion_key_pair" {
  source  = "cloudposse/key-pair/aws"
  version = "0.16.0"

  name = join("", [var.name, "-", var.environment, "-", "bastion-key"])

  ssh_public_key_path   = "ec2-keys"
  generate_ssh_key      = true
  private_key_extension = ".pem"
  public_key_extension  = ".pub"

  tags = {
    Name        = "${var.name}-${var.environment}-bastion-key"
    Environment = var.environment
    Terraform   = "Yes"
  }
}

module "instance_a" {
  source     = "../../modules/bastion"
  depends_on = [module.bastion_key_pair]

  name                          = "instance_a"
  environment                   = var.environment
  ami_id                        = "ami-080e1f13689e07408"
  instance_type                 = "t2.micro"
  key_pair_name                 = module.bastion_key_pair.key_name
  bastion_ssh_user              = local.bastion_ssh_user
  vpc_id                        = module.network.vpc_id
  subnet_ids                    = module.network.public_subnet_ids
  security_group_ids            = [aws_security_group.bastion.id]
  public_ip_address             = true
  root_block_device_volume_size = 30
  user_data_base64 = base64encode(templatefile("templates/instancea_userdata.sh.tpl", {
    capact_cli_version = ""
    capact_user        = ""
  }))
}

module "instance_b" {
  source     = "../../modules/bastion"
  depends_on = [module.bastion_key_pair]

  name                          = "instance_b"
  environment                   = var.environment
  ami_id                        = "ami-080e1f13689e07408"
  instance_type                 = "t2.micro"
  key_pair_name                 = module.bastion_key_pair.key_name
  bastion_ssh_user              = local.bastion_ssh_user
  vpc_id                        = module.network.vpc_id
  subnet_ids                    = module.network.public_subnet_ids
  security_group_ids            = [aws_security_group.bastion.id]
  public_ip_address             = true
  root_block_device_volume_size = 30
  user_data_base64 = base64encode(templatefile("templates/instanceb_userdata.sh.tpl", {
    capact_cli_version = ""
    capact_user        = ""
  }))
}

module "instance_c" {
  source     = "../../modules/bastion"
  depends_on = [module.bastion_key_pair]

  name                          = "instance_c"
  environment                   = var.environment
  ami_id                        = "ami-080e1f13689e07408"
  instance_type                 = "t2.micro"
  key_pair_name                 = module.bastion_key_pair.key_name
  bastion_ssh_user              = local.bastion_ssh_user
  vpc_id                        = module.network.vpc_id
  subnet_ids                    = module.network.public_subnet_ids
  security_group_ids            = [aws_security_group.bastion.id]
  public_ip_address             = true
  root_block_device_volume_size = 30
  user_data_base64 = base64encode(templatefile("templates/instancec_userdata.sh.tpl", {
    capact_cli_version = ""
    capact_user        = ""
  }))
}
