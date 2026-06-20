# mod-aws-alb

Módulo Terraform para crear un Application Load Balancer con Target Groups y Listeners configurables vía maps (`for_each`). Sin soporte de access logs S3 (fuera de alcance para una POC simple); soporte HTTPS/ACM disponible pero opcional.

## Uso (HTTP simple, 1 target group)

```hcl
module "alb" {
  source = "git::https://github.com/sergiohl1324/mod-aws-alb.git?ref=main"

  project             = "poc"
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.public_subnets
  security_group_ids  = [module.sg_alb.security_group_id]

  target_groups = {
    web = {
      port = 80
      health_check = {
        path = "/"
      }
    }
  }

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      default_action = {
        type             = "forward"
        target_group_key = "web"
      }
    }
  }
}
```

## Outputs principales

`alb_dns_name` (usar con `curl`), `target_group_arns` (map, usar `module.alb.target_group_arns["web"]` para registrar instancias).
