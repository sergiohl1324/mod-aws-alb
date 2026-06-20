# mod-aws-alb

Terraform module to create an Application Load Balancer with Target Groups and Listeners configurable via maps (`for_each`). No S3 access logs support (out of scope for a simple POC); HTTPS/ACM support is available but optional.

## Usage (simple HTTP, 1 target group)

```hcl
module "alb" {
  source = "git::https://github.com/sergiohl1324/mod-aws-alb.git?ref=main"

  project             = "poc"
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.public_subnets
  security_group_ids  = [module.sg_alb.this_security_group_id]

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

## Main outputs

`alb_dns_name` (use with `curl`), `target_group_arns` (map, use `module.alb.target_group_arns["web"]` to register instances).
