locals {
  prometheus_operator_namespace = "monitoring"
}

resource "helm_release" "monitoring" {
  count = var.install_prometheus_operator ? 1 : 0

  name      = "monitoring"
  chart     = "stable/prometheus-operator"
  version   = var.prometheus_operator_helm_chart_version
  namespace = local.prometheus_operator_namespace

  values = var.prometheus_operator_helm_values

  #depends_on = [
  #  kubernetes_deployment.tiller_deploy,
  #]
}