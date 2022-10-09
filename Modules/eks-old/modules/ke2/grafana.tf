locals {
  grafana_name      = "grafana"
  grafana_namespace = "kube-system"
}

resource "helm_release" "grafana" {
  count = var.install_grafana ? 1 : 0

  name      = local.grafana_name
  chart     = "stable/${local.grafana_name}"
  version   = var.grafana_helm_chart_version
  namespace = local.grafana_namespace

  wait = true

  set_sensitive {
    name  = "adminPassword"
    value = var.grafana_admin_password
  }

  values = var.grafana_helm_values

  # depends_on = [kubernetes_deployment.tiller_deploy]
}
