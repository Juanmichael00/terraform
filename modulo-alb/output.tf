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
