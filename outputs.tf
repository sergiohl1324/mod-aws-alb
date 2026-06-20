### ALB ###

output "alb_id" {
  description = "ID del Application Load Balancer"
  value       = aws_lb.alb.id
}

output "alb_arn" {
  description = "ARN del Application Load Balancer"
  value       = aws_lb.alb.arn
}

output "alb_name" {
  description = "Nombre del Application Load Balancer"
  value       = aws_lb.alb.name
}

output "alb_dns_name" {
  description = "DNS name del ALB — usar para probar con curl o registros Route53"
  value       = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  description = "Hosted Zone ID del ALB (requerido para registros Route53 Alias)"
  value       = aws_lb.alb.zone_id
}

### TARGET GROUPS ###

output "target_group_arns" {
  description = "Mapa de ARNs de los Target Groups (clave = key del mapa target_groups)"
  value       = { for k, tg in aws_lb_target_group.tg : k => tg.arn }
}

output "target_group_names" {
  description = "Mapa de nombres de los Target Groups"
  value       = { for k, tg in aws_lb_target_group.tg : k => tg.name }
}

### LISTENERS ###

output "listener_arns" {
  description = "Mapa de ARNs de los Listeners (clave = key del mapa listeners)"
  value       = { for k, l in aws_lb_listener.listener : k => l.arn }
}
