module "eks_blueprints_addons" {
  depends_on = [ module.eks ]
  source = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0"

  cluster_name      = var.stamp
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = aws_iam_openid_connect_provider.eks.arn

  
  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }
  enable_aws_load_balancer_controller    = true
  aws_load_balancer_controller = {
        set = [
      {
        name  = "vpcId"
        value = module.vpc.vpc_id
      },
      {
        name  = "region"
        value = "us-east-1"
      },
    ]
    timeout = 900
    wait = true
  }
  cert_manager_route53_hosted_zone_arns  = ["arn:aws:route53:::hostedzone/Z042342135LJBKJYB56SB"]
  
  tags = {
    terraform = true
  }
}

#aws eks --region us-east-1  update-kubeconfig --name octopus --role-arn arn:aws:iam::058264364931:role/_LocalAdmin


resource "helm_release" "nginx-controller" {
  depends_on = [ module.eks_blueprints_addons ]
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress"
  create_namespace = true
  set {
    name  = "controller.service.type"
    value = "ClusterIP"
  }
  timeout = 900
  wait    = true
}

resource "kubernetes_ingress_v1" "nginx_alb" {
  depends_on = [ helm_release.nginx-controller, module.eks_blueprints_addons.aws_load_balancer_controller, module.eks_blueprints_addons.aws_ebs_csi_driver ]
  metadata {
    name      = "nginx-ingress"
    namespace = "ingress"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/ssl-redirect"    = 443
      "alb.ingress.kubernetes.io/target-type"     = "ip"
      "alb.ingress.kubernetes.io/listen-ports"    = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
      "alb.ingress.kubernetes.io/certificate-arn" = module.acm.acm_certificate_arn
    }
  }
  
  
  spec {
    ingress_class_name = "alb"
    rule {
      
      http {
        path {
          path     = "/*"
          backend {
            service {
              name = "ingress-nginx-controller"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

resource "helm_release" "argocd" {
  depends_on = [ helm_release.nginx-controller, kubernetes_ingress_v1.nginx_alb ]
  name             = "argocd"
  namespace        = "argocd"
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  version          = "7.7.11"
  create_namespace = true
set {
  name  = "server.ingress.enabled"
  value = "true"
}
set {
  name = "crds.keep"
  value = false
}

set {
  name  = "server.ingress.ingressClassName"
  value = "nginx"
}

set {
  name  = "global.domain"
  value = "argocd.${var.domain}"
}

set {
  name  = "server.ingress.path"
  value = "/"
}

set {
  name  = "server.ingress.pathType"
  value = "Prefix"
}
set {
  name = "configs.params.server\\.insecure"
  value = true
}
set {
  name  = "server.ingress.annotations"
  value = jsonencode({
    "kubernetes.io/ingress.class"                  = "nginx"
    })
  }

  timeout = 900
  wait    = true
}