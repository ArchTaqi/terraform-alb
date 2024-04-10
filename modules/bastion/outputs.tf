output "instance_id" {
  value       = module.bastion.instance_id
  description = "Instance ID"
}

output "security_group_ids" {
  value       = module.bastion.security_group_ids
  description = "Security group IDs"
}

output "role" {
  value       = module.bastion.role
  description = "Name of AWS IAM Role associated with the instance"
}

output "public_ip" {
  value       = module.bastion.public_ip
  description = "Public IP of the instance (or EIP)"
}

output "private_ip" {
  value       = module.bastion.private_ip
  description = "Private IP of the instance"
}

output "private_dns" {
  description = "Private DNS of instance"
  value       = module.bastion.private_dns
}

output "public_dns" {
  description = "Public DNS of instance (or DNS of EIP)"
  value       = module.bastion.public_dns
}

output "id" {
  description = "Disambiguated ID of the instance"
  value       = module.bastion.id
}

output "arn" {
  description = "ARN of the instance"
  value       = module.bastion.arn
}

output "name" {
  description = "Instance name"
  value       = module.bastion.name
}

output "security_group_id" {
  value       = module.bastion.security_group_id
  description = "Bastion host Security Group ID"
}

output "security_group_arn" {
  value       = module.bastion.security_group_arn
  description = "Bastion host Security Group ARN"
}

output "security_group_name" {
  value       = module.bastion.security_group_name
  description = "Bastion host Security Group name"
}
