### GLOBAL VARIABLES ###

variable "project" {
  description = "Project or application name"
  type        = string
  default     = "poc"
}

variable "environment" {
  description = "Logical environment (e.g. nonproduction, production) used for tagging"
  type        = string
  default     = "nonproduction"
}

variable "tags" {
  description = "Additional tags merged with the default tags"
  type        = map(string)
  default     = {}
}

### ALB VARIABLES ###

variable "vpc_id" {
  description = "ID of the VPC where the Target Groups will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ALB (public for internet-facing, private for internal)"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of Security Group IDs attached to the ALB"
  type        = list(string)
}

variable "internal" {
  description = "If true, the ALB will be internal and not accessible from the internet"
  type        = bool
  default     = false
}

variable "idle_timeout" {
  description = "Time in seconds a connection is allowed to remain idle"
  type        = number
  default     = 60
}

variable "enable_deletion_protection" {
  description = "If true, protects the ALB against accidental deletion via the AWS API"
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "Enables HTTP/2 on the ALB"
  type        = bool
  default     = true
}

### TARGET GROUP VARIABLES ###

variable "target_groups" {
  description = "Map of Target Groups to create. The key is the identifier used in listeners"
  type = map(object({
    name                 = optional(string)
    port                 = number
    protocol             = optional(string, "HTTP")
    target_type          = optional(string, "instance")
    deregistration_delay = optional(number, 300)
    health_check = optional(object({
      enabled             = optional(bool, true)
      path                = optional(string, "/")
      port                = optional(string, "traffic-port")
      protocol            = optional(string, "HTTP")
      matcher             = optional(string, "200")
      interval            = optional(number, 30)
      timeout             = optional(number, 5)
      healthy_threshold   = optional(number, 3)
      unhealthy_threshold = optional(number, 3)
    }))
  }))
  default = {}
}

### LISTENER VARIABLES ###

variable "listeners" {
  description = "Map of Listeners to create on the ALB. The key is the listener identifier"
  type = map(object({
    port            = number
    protocol        = string
    ssl_policy      = optional(string, "ELBSecurityPolicy-TLS13-1-2-2021-06")
    certificate_arn = optional(string)
    default_action = object({
      type             = string
      target_group_key = optional(string)
      redirect = optional(object({
        status_code = string
        protocol    = optional(string, "HTTPS")
        port        = optional(string, "443")
      }))
      fixed_response = optional(object({
        content_type = string
        message_body = optional(string)
        status_code  = optional(string, "200")
      }))
    })
  }))
  default = {}
}
