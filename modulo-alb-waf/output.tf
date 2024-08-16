output "alb_name" {
  description = "Nome do ALB criado"
  value       = aws_lb.alb_teste.name
}

output "alb_dns_name" {
  description = "DNS do ALB criado"
  value       = aws_lb.alb_teste.dns_name
}

output "target_group_name" {
  description = "Nome do Target Group atachado ao ALB"
  value       = aws_lb_target_group.tg_alb_instance.name
}

output "security_group_name" {
  description = "Nome do Security Group atachado ao ALB"
  value       = aws_security_group.sg_alb_instance.name
}

output "waf_name" {
  description = "Nome do WebACL WAF criado."
  value       = aws_wafv2_web_acl.waf_acl.name
}

output "attached_alb" {
  description = "ARN do ALB associado ao WAF."
  value       = aws_wafv2_web_acl_association.waf_acl_assoc.resource_arn
}
