### APPLICATION LOAD BALANCER ###

resource "aws_lb" "alb" {
  name                       = local.alb_name
  internal                   = var.internal
  load_balancer_type         = "application"
  security_groups            = var.security_group_ids
  subnets                    = var.subnet_ids
  idle_timeout               = var.idle_timeout
  enable_deletion_protection = var.enable_deletion_protection
  enable_http2               = var.enable_http2
  drop_invalid_header_fields = true

  tags = local.common_tags
}

### TARGET GROUPS ###

resource "aws_lb_target_group" "tg" {
  for_each = var.target_groups

  name                 = coalesce(each.value.name, "${local.tg_name}-${each.key}")
  port                 = each.value.port
  protocol             = each.value.protocol
  vpc_id               = var.vpc_id
  target_type          = each.value.target_type
  deregistration_delay = each.value.deregistration_delay

  dynamic "health_check" {
    for_each = each.value.health_check != null ? [each.value.health_check] : []
    content {
      enabled             = health_check.value.enabled
      path                = health_check.value.path
      port                = health_check.value.port
      protocol            = health_check.value.protocol
      matcher             = health_check.value.matcher
      interval            = health_check.value.interval
      timeout             = health_check.value.timeout
      healthy_threshold   = health_check.value.healthy_threshold
      unhealthy_threshold = health_check.value.unhealthy_threshold
    }
  }

  tags = local.common_tags
}

### LISTENERS ###

resource "aws_lb_listener" "listener" {
  for_each          = var.listeners
  load_balancer_arn = aws_lb.alb.arn
  port              = each.value.port
  protocol          = each.value.protocol
  ssl_policy        = each.value.protocol == "HTTPS" ? each.value.ssl_policy : null
  certificate_arn   = each.value.protocol == "HTTPS" ? each.value.certificate_arn : null

  dynamic "default_action" {
    for_each = [each.value.default_action]
    content {
      type             = default_action.value.type
      target_group_arn = default_action.value.type == "forward" && default_action.value.target_group_key != null ? aws_lb_target_group.tg[default_action.value.target_group_key].arn : null

      dynamic "redirect" {
        for_each = default_action.value.redirect != null ? [default_action.value.redirect] : []
        content {
          status_code = redirect.value.status_code
          protocol    = redirect.value.protocol
          port        = redirect.value.port
        }
      }

      dynamic "fixed_response" {
        for_each = default_action.value.fixed_response != null ? [default_action.value.fixed_response] : []
        content {
          content_type = fixed_response.value.content_type
          message_body = fixed_response.value.message_body
          status_code  = fixed_response.value.status_code
        }
      }
    }
  }

  tags = local.common_tags
}
