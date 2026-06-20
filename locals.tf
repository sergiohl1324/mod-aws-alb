### NAMING ###

locals {
  alb_name = "poc-alb-${var.project}"
  tg_name  = "poc-tg-${var.project}"
}

### TAGS ###

locals {
  common_tags = merge(
    {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.tags
  )
}
