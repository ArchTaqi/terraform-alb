output "vpc_id" {
  value = module.vpc.vpc_id
}
output "vpc_arn" {
  value = module.vpc.vpc_arn
}
output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}
output "vpc_default_security_group_id" {
  value = module.vpc.vpc_default_security_group_id
}
output "public_subnet_ids" {
  value = module.subnets.public_subnet_ids
}
output "private_subnet_ids" {
  value = module.subnets.private_subnet_ids
}
output "availability_zones" {
  value = module.subnets.availability_zones
}
output "availability_zone_ids" {
  value = module.subnets.availability_zone_ids
}
