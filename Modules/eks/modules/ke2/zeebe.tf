locals {
  zeebe_name      = "zeebe-cluster"
  zeebe_namespace = "kube-system"
}

resource "helm_release" "zeebe" {
  count      = var.install_zeebe ? 1 : 0
  name       = local.zeebe_name
  repository = "https://helm.zeebe.io" 
  chart      = "zeebe-cluster"
  namespace  = local.zeebe_namespace
}
