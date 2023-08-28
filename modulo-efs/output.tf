output "id" {
  description = "The ID that identifies the file system (e.g., `fs-ccfc0d65`)"
  value       = module.efs.id
}

output "security_group_id" {
  description = "Description: ID of the security group"
  value       = module.efs.security_group_id 
}

output "mount_targets" {
  description = "Description: Map of mount targets created and their attributes"
  value       = module.efs.mount_targets 
}