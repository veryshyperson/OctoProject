module "acm" {

  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name  = var.domain
  zone_id      = data.aws_route53_zone.domain_zone.id

  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain}",
    "${var.domain}",
  ]

  wait_for_validation = true

  tags = {
    Name = "${var.stamp}-acm"

  }
  depends_on = [ module.eks_blueprints_addons ]
}

data "aws_route53_zone" "domain_zone" {
  name = var.domain
}

