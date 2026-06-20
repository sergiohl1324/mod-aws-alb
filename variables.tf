### VARIABLES GLOBALES ###

variable "project" {
  description = "Nombre del proyecto o aplicación"
  type        = string
  default     = "poc"
}

variable "environment" {
  description = "Ambiente lógico (ej. nonproduction, production) usado para tagging"
  type        = string
  default     = "nonproduction"
}

variable "tags" {
  description = "Tags adicionales que se fusionan con los tags por defecto"
  type        = map(string)
  default     = {}
}

### VARIABLES ALB ###

variable "vpc_id" {
  description = "ID de la VPC donde se crearán los Target Groups"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de subnet IDs para el ALB (públicas para externo, privadas para interno)"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Lista de Security Group IDs asignados al ALB"
  type        = list(string)
}

variable "internal" {
  description = "Si true, el ALB será interno y no accesible desde internet"
  type        = bool
  default     = false
}

variable "idle_timeout" {
  description = "Tiempo en segundos que la conexión puede permanecer inactiva"
  type        = number
  default     = 60
}

variable "enable_deletion_protection" {
  description = "Si true, protege el ALB contra eliminación accidental vía API de AWS"
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "Habilita HTTP/2 en el ALB"
  type        = bool
  default     = true
}

### VARIABLES TARGET GROUPS ###

variable "target_groups" {
  description = "Mapa de Target Groups a crear. La clave es el identificador usado en los listeners"
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

### VARIABLES LISTENERS ###

variable "listeners" {
  description = "Mapa de Listeners a crear en el ALB. La clave es el identificador del listener"
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
