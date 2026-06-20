### ALB ###

output "alb_id" {
  description = "Application Load Balancer ID"
  value       = aws_lb.alb.id
}

output "alb_arn" {
  description = "Application Load Balancer ARN"
  value       = aws_lb.alb.arn
}

output "alb_name" {
  description = "Application Load Balancer name"
  value       = aws_lb.alb.name
}

output "alb_dns_name" {
  description = "ALB DNS name — use it to test with curl or for Route53 records"
  value       = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  description = "ALB Hosted Zone ID (required for Route53 Alias records)"
  value       = aws_lb.alb.zone_id
}

### TARGET GROUPS ###

output "target_group_arns" {
  description = "Map of Target Group ARNs (key = target_groups map key)"
  value       = { for k, tg in aws_lb_target_group.tg : k => tg.arn }
}

output "target_group_names" {
  description = "Map of Target Group names"
  value       = { for k, tg in aws_lb_target_group.tg : k => tg.name }
}

### LISTENERS ###

output "listener_arns" {
  description = "Map of Listener ARNs (key = listeners map key)"
  value       = { for k, l in aws_lb_listener.listener : k => l.arn }
}
