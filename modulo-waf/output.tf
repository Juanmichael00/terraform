output "waf_name" {
  description = "Nome do WebACL WAF criado."
  value       = aws_wafv2_web_acl.waf_acl.name
}

output "attached_alb" {
  description = "ARN do ALB associado ao WAF."
  value       = aws_wafv2_web_acl_association.waf_acl_assoc.resource_arn
}