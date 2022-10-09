# terraform-aws-eks-openid-connect

Usage:

```hcl-terraform
module "eks_openid_connect" {
  source = "git@github.com:kabisa/terraform-aws-eks-openid-connect.git?ref=1.3.0"
  # tf 0.13
  # depends_on              = [module.eks]
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  region                  = var.region
}
```
