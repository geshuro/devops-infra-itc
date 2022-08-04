locals {
  prometheus_name      = "prometheus"
  prometheus_namespace = "prometheus"
}

resource "kubernetes_namespace" "prometheus" {
  count = var.install_prometheus ? 1 : 0
  metadata {
        name = local.prometheus_namespace
  }
}


resource "helm_release" "prometheus" {
  count = var.install_prometheus ? 1 : 0

  name      = local.prometheus_name
  chart     = "stable/${local.prometheus_name}"
  version   = var.prometheus_helm_chart_version
  namespace = local.prometheus_namespace


  set {
    name  = "alertmanager.persistentVolume.storageClass"
    value = "gp2"
  }

  set {
    name  = "server.persistentVolume.storageClass"
    value = "gp2"
  }

  values = var.prometheus_helm_values

  depends_on = [
    kubernetes_deployment.tiller_deploy,
    helm_release.aws_alb_ingress,
    kubernetes_namespace.prometheus
  ]
}
