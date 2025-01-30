data "tls_certificate" "eks" {
  url = module.eks.cluster_oidc_issuer_url
}

resource "aws_iam_openid_connect_provider" "eks" {
  url                 = module.eks.cluster_oidc_issuer_url
  client_id_list      = ["sts.amazonaws.com"]
  thumbprint_list     = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
}

module "eks" {
  depends_on = [ module.vpc ]
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.stamp
  cluster_version = "1.31"

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true
  enable_irsa = false

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets

  # EKS Managed Node Group(s)

  cluster_addons = {
    coredns = {}

    vpc-cni = {}

    kube-proxy = {}
    
    eks-pod-identity-agent = {}
  }

  eks_managed_node_groups = {
    TeamOctopus = {
      instance_type = var.ec2_type
      
      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.desired_size 

      iam_role_additional_policies = {
        SecretsManagerReadWrite = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
        EBSCSIDriver           = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    }
  }
}

  tags = {
    Terraform   = "true"
  }
}